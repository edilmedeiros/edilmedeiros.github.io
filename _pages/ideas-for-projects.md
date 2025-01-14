---
layout: page
title: Ideas for Projects
---

# Ideas for Projects in Bitcoin

Below you'll find some ideas for projects to be developed in the Bitcoin space.
Most are thought to be developed by undergraduate students in a two semester
project. Some could clearly be expanded as Master's projects. If you have
additional ideas, please send a PR to [this
website](https://github.com/edilmedeiros/edilmedeiros.github.io).

---

- Análise on-chain

Desenvolver algo semelhante ao https://bitcoinisdata.info (com um escopo inicial menor, claro), coletar a blockchain e analisar dados (por exemplo, quantas utxos existem, quais os tipos de contrato seriam os mais comuns, etc)Abordagem mais pragmática poderia usar o Bitcoin Core para acessar a blockchain e ler os dados pela interface RPC.Outra abordagem poderia ser desenvolver um cliente leve que consulta os dados via rede p2p.

- Crawler de Bitcoin

Desenvolver algo semelhante ao https://bitnodes.io, um crawler de bitcoin que tenta descobrir informações sobre os nodes que compõem a rede, os ips, etc.

- Minerador da signet

Reimplementar esse script: https://github.com/bitcoin/bitcoin/tree/35bf426e02210c1bbb04926f4ca2e0285fbfcd11/contrib/signet.Não acredito que seria incluído no Bitcoin Core, mas acho que poderia ser um projeto muito interessante.Minha ideia é fazer ele numa arquitetura cliente-servidor, com uma interface de linha de comando semelhante ao conjunto bitcoind+bitcoin-cli.

- Análise de dados do repositório do Bitcoin Core

Talvez seja um trabalho interessante do ponto de vista de engenharia de software, analisar o histórico do git do Bitcoin Core (https://github.com/bitcoin/bitcoin).Mapear quem são os contribuidores mais ativos, as áreas de código mais trabalhadas ao longo do tempo, comportamento da issues e PRs, etc.

- Outros projetos de monitoramento da rede

O b10c (https://b10c.me) desenvolve vários projetos de monitoramento da rede: https://mempool.observer/, https://mempool.observer/monitor, https://transactionfee.info/, https://miningpool.observer/, https://fork.observer/. Podemos contribuir com algum dos projetos (ele se mostrou interessado em mentorar esse tipo de trabalho recentemente).

Ver https://github.com/0xB10C/project-ideas/issues/8

- Krux (https://selfcustody.github.io/krux/)

A Krux é uma wallet em hardware cujo principal desenvolvedor é um colega meu. Podemos escolher uma ou duas issues marcadas como [Enhancement] (https://github.com/selfcustody/krux/issues) e implementar.

- Padronização da interface RPC do Bitcoin Core

Esse é um projeto um pouco mais ambicioso, mas acho que daria para implementar um piloto, em especial já visando um mestrado na sequência.Problema: o Bitcoin Core tem duas interfaces: p2p e RPC. A interface RPC é usada pelos operadores do nó para enviar comandos para o software, é a interface utilizada pela maioria dos clientes que precisam interagir com um nó de bitcoin. É uma interface JSON que funciona como um HTTP server, mas os métodos são uma bagunça, mudam toda hora e é difícil implementar um cliente de forma automática (todo mundo faz clientes custom-made para partes mais específicas). Existe um desejo de padronizar essa interface de forma a gerar clientes de forma automática (ver discussão em https://github.com/bitcoin/bitcoin/issues/29912 e https://github.com/rust-bitcoin/corepc/issues/4). Acho que seria possível pegar o trabalho começado em https://github.com/casey/bitcoin/tree/rpc-json que exporta um json e montar um programa que gera código do cliente a partir dessa especificação em formato de máquina.

- Nerdminer v3

Nerdminer é um pequeno hardware de mineração com microcontroladores. Ele é a base de outros projetos mais sérios que usam ASICs industriais. O hardware sae conecta numa pool de mineração por meio de um protocolo chamado Stratum. Esse protocolo tem uma nova versão (https://stratumprotocol.org) com implementação de referência em Rust. Uma ideia seria reimplementar o nerdminer (https://github.com/BitMaker-hub/NerdMiner_v2) em Rust. Essas placas ESP-32 tem suporte para Rust embarcado, seria um projeto bem de ponta também e no escopo do TCC teria que ser dividido em partes menores para não ficar com escopo muito grande.

- Bitaxe + Stratum v2

Mesma coisa acima, mas visando placas com hashrate maior (https://bitaxe.org).

- Covenant

Essa também é uma discussão de fronteira, investigar as diferentes propostas de covenants para o Bitcoin (https://covenants.info). A ideia seria começar uma pesquisa na linha deste relatório: https://bitcoinrollups.org
