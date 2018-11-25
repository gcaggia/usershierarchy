# User Hierarchy

Developed with [Crystal](https://crystal-lang.org/), a new langage inspired by Ruby and extremely fast like C/C++ code.

Run as an API, thanks to [Kemal](http://kemalcr.com/), a powerful, simple and sinatra-like framework.

Dockerized and available on dockerhub:
```bash
docker run -p 8080:8080 gcaggia/usershierarchy:latest
```

To use: 
```bash
curl localhost:8080/api/get-subordinates/3
```

## File organization
- solution.cr: solution of the problem 
- api.cr: web server and api to execute the code
- shard files: shard is the dependency manager for Crystal (like composer/gem/npm...)
- data folder: json files used for the problem
- spec folder: important folder to test the app. Have a look to api_spec file, it tests the app with a crystal tool similar to rspec or mochajs
- Dockerfile: my favourite file... What would be my life without Docker?

## Solution of the problem

A user has a role id. To get all his subordinates, we find all the subordinates of the role of the user. Then, for each user who matches that list, we keep him.

Why working on the list of roles whereas the list of users ?

Two users can have the same role, but a role is unique.

Consequence: number_of(roles) << number_of(users).

And the complexity of the algorithm is O(roles). 

## Installation and use

### The "Docker" approach

You will need to have docker installed on your computer.
```bash
docker run -d -p 8080:8080 gcaggia/usershierarchy:latest
```

Then, to see an answer following the data of the challenge, for instance user id = 3:
```bash
curl localhost:8080/api/get-subordinates/3
```

You can also provide your own data. For that, first, create a folder, let's call it data. Let's use the json models of users and roles. Copy them on your data local folder using curl with a redirection:
```bash
mkdir data
```
```bash
curl https://raw.githubusercontent.com/gcaggia/usershierarchy/master/data/users.json > data/user.json
```
```bash
curl https://raw.githubusercontent.com/gcaggia/usershierarchy/master/data/roles.json > data/roles.json
```

Now, when you start your container, map the local volume with its equivalent inside the container with a -v flag:
```bash
docker run -d -p 8080:8080 -v $(pwd)/data:/app/data gcaggia/usershierarchy:latest
```

It is time to play! When you change your json file, it will automatically change the response of the server. Game: let's create a complex organisation and try to crash the program!

### The "hard way" approach

You will need to install crystal
```bash
brew update
brew install crystal
```

Then, you can clone the project
```bash
git clone https://github.com/gcaggia/usershierarchy.git
```
To run it, a nice way is to use two terminals or an horizontal split: one for the server, and one for the client for curl.

```bash
crystal api.cr
```
```bash
curl localhost:8080/api/get-subordinates/3
```

More information about the installation:
https://crystal-lang.org/docs/installation/

## Unit tests

To test the app, you will need to install it using the "hard way" method.

Then, just simply run this command:
```bash
KEMAL_ENV=test crystal spec -v
```

It will start a couple of automatic tests to see if everything is fine. Examples of the challenge will be test automatically.

## Performance

In production, The api responds in 150 µs in average. It runs in a docker container on a litle compute engine (shared cpu with 0.6 go of ram). OS is docker optimized by Google.

150 µs to get an incoming request, parse a JSON file, apply an algorithm and send a response. 

This challenge was also a study to analyze the behaviour of Crystal and to compare it with other langages.