
 
 
```
docker build . -f nodejs-min.dockerfile -t nodejs-min
```

```
docker run -di -p 4000:4000 -p 22:22 --name nodejs-min nodejs-min
```





