---
layout: page
title: Construindo uma rede Bitcoin privada com signet
---

Vamos começar clonando o repositório do bitcoin-core (se você ainda não fez isso).
```bash
cd ~
git clone https://github.com/bitcoin/bitcoin.git
```

Se você quiser compilar a partir do código-fonte, instale as dependências (no mínimo `boost` e `sqlite`) e faça algo como:
```bash
cd bitcoin
git checkout v27.0
./configure --enable-wallet --with-gui=no
make
```
Nesse caso, os binários estarão na pasta `~/bitcoin/src/`.

É essencial que você compile o cliente bitcoin com suporte a carteira.
Para isso, certifique-se de que a saída do comando `./configure` indique que a carteira será compilada.
```bash
options used to compile and link:
...
  with wallet     = yes
    with sqlite   = yes
    with bdb      = no
```

Você também pode instalar os [binários oficiais](), mas ainda assim vamos precisar do código-fonte.
Vamos precisar de um diretório para que o full node guarde seu estado.
```bash
mkdir bitcoin-datadir
```

Vamos configurar algumas variáveis de ambiente para encurtar alguns comandos.
```bash
# Diretório com os binários
export BTC_PATH=~/bitcoin/src

# Diretório para arquivos de estado do full node
export SIGNET_DATADIR=~/bitcoin-datadir

# Cliente bitcoin
alias btcd="$BTC_PATH/bitcoind -datadir=$SIGNET_DATADIR"

# Interface de linha de comando
alias bcli="$BTC_PATH/bitcoin-cli -datadir=$SIGNET_DATADIR"
BCLI="$BTC_PATH/bitcoin-cli -datadir=$SIGNET_DATADIR"

# Script de mineração da signet
alias miner="$BTC_PATH/../contrib/signet/miner"

# Bitcoin-util, que vai calcular a prova de trabalho
GRINDER="$BTC_PATH/bitcoin-util grind"
```

Vamos também precisar do `jq`, instale com o gerenciador de pacotes da sua distribuição.

### Criar o desafio da signet

Para criar o desafio da signet, vamos criar uma carteira na regtest e construir um script a partir de um novo endereço de bitcoin.
```bash
# Iniciar o node na regtest
btcd -regtest -daemon

# Criar uma nova carteira
bcli -regtest createwallet "signer"
```

Precisamos exportar as chaves privadas dessa carteira pois sem elas nào vamos conseguir assinar os blocos da nossa signet.
```bash
DESCRIPTORS=$(bcli -regtest listdescriptors true | jq -r .descriptors)
```

A seguir, vamos criar um novo endereço controlado pela nossa carteira.
É a partir deste endereço que vamos criar o desafio da signet.
```bash
# Criar novo endereço
ADDR=$(bcli -regtest -named getnewaddress address_type="bech32")
```

Enfim, vamos criar o desafio da signet.
```bash
# Criar o desafi oda signet
SIGNET_CHALLENGE=$(bcli -regtest -named getaddressinfo $ADDR | jq -r .scriptPubKey)
```

Temos todas as informações necessárias nas variáveis de ambiente.
Podemos parar o node e subir a signet.
```bash
bcli -regtest stop
```

### Rodar a signet

Vamos criar um arquivo de configuração para o full node.
```bash
echo "signet=1
[signet]
daemon=1
signetchallenge=$SIGNET_CHALLENGE" > $SIGNET_DATADIR/bitcoin.conf
```

Iniciar o node.
```bash
btcd
```

Agora vamos importar nossas chaves privadas.
```bash
# Criar nova carteira
bcli createwallet "miner"

# Importar chaves privadas
bcli importdescriptors "$DESCRIPTORS"
```

Vamos criar um novo endereço para receber os bitcoins minerados na signet.
```bash
MINER_ADDR=$(bcli getnewaddress address_type="bech32")
```

Pronto, temos todas as informações que precisamos para minerar blocos.
Para rodar o minerador continuamente, fazemos:
```bash
miner --cli $BCLI generate --address $MINER_ADDR --grind-cmd $GRINDER --min-nbits --ongoing
```

## Brincando de signet

Utilize a seguinte configuração no seu [`bitcoin.conf`](assets/signet-workshop/bitcoin.conf):
```bash
signet=1
[signet]
daemon=1
signetchallenge=00147ea677b054751d543541cd1149c5d20db5112d2f
```

Adicione o meu node fazendo:
```bash
bcli addnode "<ip>" "add"
```

Para minerar, importe esses [descritores](assets/signet-workshop/descriptors.txt).
