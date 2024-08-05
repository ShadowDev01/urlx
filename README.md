# Intro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# extract url objects - URLX
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Install
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                              *** julia ***

# install julia: https://julialang.org/downloads/   or   snap install julia --classic
# then run this commands in terminal:

* 1. julia -e 'using Pkg; Pkg.add("ArgParse"); Pkg.add("JSON"); Pkg.add("OrderedCollections")'
* 2. git clone https://github.com/mrmeeseeks01/urlx.git
* 3. cd urlx/
* 4. julia urlx.jl -h


# or you can use docker:

* 1. git clone https://github.com/mrmeeseeks01/urlx.git
* 2. cd urlx/
* 3. docker build -t urlx .
* 4. docker run urlx
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Switches
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# optional arguments:

*  -h, --help            show this help message and exit
*  -u, --url             single url
*  -U, --urls            list of urls in file
*  --stdin               read url(s) from stdin
*  --scheme              print url scheme
*  --username            print url username
*  --password            print url password
*  --auth                print url authenticate
*  --host                print url host
*  --domain              print url domain
*  --subdomain           print url subdomain
*  --tld                 print url tld
*  --port                print url port
*  --path                print url path
*  --directory           print url directory
*  --file                print url file
*  --file_name           print url file_name
*  --file_ext            print url file_extension
*  --query               print url query
*  --keys                print all keys in query in unique
*  --values              print all values in query in unique
*  --keypairs            key=value pairs from the query string (one per line)
*  --fragment            print url fragment
*  --format FORMAT       Specify a custom format (default: "")
*  --json                JSON encoded url/format objects
*  --decode              simple url & html decode
*  -c                    count and sort descending
*  --cn                  count and sort descending with numbers
*  -o, --output          save output in file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --format Directives
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%sc  =>  url scheme
%SC  =>  from the beginning of url to the scheme
%un  =>  url username
%pw  =>  url password
%au  =>  from the beginning of url to the authenticate
%ho  =>  url host
%HO  =>  from the beginning of url to the host
%sd  =>  url subdomain
%do  =>  url domain
%tl  =>  url tld
%po  =>  url port
%PO  =>  from the beginning of url to the port
%pa  =>  url path
%PA  =>  from the beginning of url to the path
%di  =>  url directory
%fi  =>  url file
%fn  =>  url file_name
%fe  =>  url file_extension
%qu  =>  url query
%QU  =>  from the beginning of url to the query
%fr  =>  url fragment
%FR  =>  from the beginning of url to the fragment
%pr  =>  url parameters in space separated
%PR  =>  url parameters in new line
%va  =>  url values of parameters in space separated
%VA  =>  url values of parameters in new line
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Examples
```
  url = "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11"
```

<br>

* for custom threads, should pass -t [int] to julia
~~~
> julia -t [int] urlx.jl [switches]
~~~

<br>

* give single url to urlx
~~~
> julia urlx.jl -u [url] [switches]
~~~

<br>

* give url(s) in file to urlx
~~~
> julia urlx.jl -U [file] [switches]
~~~

<br>

* give url(s) from stdin to urlx
~~~
> cat [file] | julia urlx.jl --stdin [switches]


> echo "url" | julia urlx.jl --stdin [switches]
~~~

<br>

* using --json option
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --json

[
    {
        "raw_url": "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11",
        "decoded_url": "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11",
        "scheme": "https",
        "username": "admin",
        "password": "1234",
        "auth": "admin:1234",
        "host": "auth.admin-user.company.co.com",
        "subdomain": "auth.admin-user",
        "subdomain_combination": [
            "auth.admin-user",
            "auth",
            "admin",
            "user",
            "admin-user"
        ],
        "domain": "company",
        "tld": "co.com",
        "port": "443",
        "path": "/dir1/dir2/file.js",
        "directory": "/dir1/dir2",
        "file": "file.js",
        "file_name": "file",
        "file_ext": "js",
        "query": "id=44&status=null&log",
        "query_params": [
            "id",
            "status",
            "log"
        ],
        "query_values": [
            "44",
            "null"
        ],
        "query_paires": {
            "id": "44",
            "status": null,
            "log": ""
        },
        "query_params_count": 3,
        "query_values_count": 2,
        "fragment": "page~11"
    }
]
~~~


<br>

* using --keys 
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --keys

id
status
log
~~~

<br>

* using --keys -c 
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --keys -c

id
status
log
~~~

<br>

* using --keys --cn 
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --keys --cn

id: 1
status: 1
log: 1
~~~

<br>

* using --values
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --values

44
null
~~~

<br>

* using --values -c
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --values -c

44
null
~~~

<br>

* using --values --cn
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --values --cn

44: 1
null: 1
~~~

<br>

* using --keypairs 
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --keypairs

id=44
status=null
log=
~~~

<br>

* using --keypairs -c
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --keypairs -c

id=44
status=null
log=
~~~

<br>

* using --keypairs --cn
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --keypairs --cn

id=44: 1
status=null: 1
log=: 1
~~~

<br>

* using --format option
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --format "%sc"

https
~~~

~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --format "%sc %do %po"

https company 443
~~~

* using --format [string] -c
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --format "%sc" -c

https
~~~

* using --format [string] --cn
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --format "%sc %do %po" --cn

https company 443: 1
~~~
