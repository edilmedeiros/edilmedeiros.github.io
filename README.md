# Edil Medeiros Website

There's a `new-site` branch where the development takes place. 
When something is commited to the `main` branch, an action publishes the website using Github Pages to a custom domain `edil.com.br`.

The website is built with Jekyll and a customized version of the [Avenco](https://avenco.netlify.app) theme.

## Build site locally

1. Install Ruby, the version embedded by Apple is not usable.

``` bash
sudo port install ruby33
sudo port select --set ruby ruby33
```

2. Install Bundle and Jekkyl

``` bash
gem install bundle jekyll
```

3. Add Ruby dir to path

``` bash
export PATH=/Users/<user>/.local/share/gem/ruby/3.3.0/bin:$PATH
```

4. Install gems

``` bash
cd <site-sir>
bundle install
```

5. Serve local site

``` bash
bundle exec jekyll serve
```
