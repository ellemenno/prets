# notes

## local serve

> provide a simple local webhost to serve the static files and allow validation before committing

https://github.com/avleen/bashttpd/blob/master/README.md
https://funprojects.blog/2021/04/11/a-web-server-in-1-line-of-bash/

```console
while true; do { \
  echo -ne "HTTP/1.0 200 OK\r\nContent-Length: $(wc -c <index.htm)\r\n\r\n"; \
  cat index.htm; } | nc -l -p 8080 ; \
done
```

https://gist.github.com/willurd/5720255

$ python -m http.server 8000
$ ruby -run -ehttpd . -p8000
$ jwebserver -p 8080

$ npm install -g node-static # install dependency
$ static -p 8000

$ npx servor <root> <fallback> <port>
https://www.npmjs.com/package/servor

node code https://gist.github.com/mLuby/6cecf50649c543b6c89f3976cf203058
bash code https://funprojects.blog/2021/04/11/a-web-server-in-1-line-of-bash/

nginx via docker


## auto-versioning

> set version number to current total deployments +1 so that when commit triggers deployment, version and deployment count match

https://github.com/ellemenno/prets/deployments

once the number of deployments exceeds the pagination threshold (30 - 100), the github api for deployments requires multiple calls to first get a list and a data structure with a link to the last page, and then to retrieve the last page and determine the latest deployment id / count:
https://docs.github.com/en/rest/deployments/deployments?apiVersion=2022-11-28#list-deployments

or, since we are deploying using the gh-pages worktree, each commit to that tree triggers a deployment, so we could also use the code metrics api and look for total commits on the gh-pages branch, but this is also paginated:
https://docs.github.com/en/rest/metrics/statistics?apiVersion=2022-11-28

so, looking to graphQL api instead:
https://docs.github.com/en/graphql

