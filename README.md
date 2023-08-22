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
* 4. docker run -it urlx
* 5. press ; to enabled shell mode
* 6. julia urlx.jl -h
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Switches
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# optional arguments:

*  -h, --help            show this help message and exit
*  -u, --url             single url
*  -U, --urls            list of urls in file
*  --stdin               read url(s) from stdin
*  --keypairs            key=value pairs from the query string (one per line)
*  --format FORMAT       Specify a custom format (default: "")
*  --json                JSON encoded url/format objects
*  --show                show url objects in texts
* --decode               simple url & html decode
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

{
    "url": "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11",
    "scheme": "https",
    "username": "admin",
    "password": "1234",
    "authenticate": "admin:1234",
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
    "fragment": "page~11",
    "parameters": [
        "id",
        "status",
        "log"
    ],
    "parameters_count": 3,
    "parameters_value": [
        "44",
        "null"
    ],
    "parameters_value_count": 2
}
~~~

<br>

* using --show option 
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --show

* url:            https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11
* scheme:         https
* username:       admin
* password:       1234
* authenticate:   admin:1234
* host:           auth.admin-user.company.co.com
* subdomain:      auth.admin-user
* domain:         company
* tld:            co.com
* port:           443
* path:           /dir1/dir2/file.js
* directory:      /dir1/dir2
* file:           file.js
* file_name:      file
* file_extension: js
* query:          ?id=44&status=null&log
* fragment:       page~11
* subdomain_comb: auth.admin-user auth admin user admin-user
* parameters:     id status log
* params count:   3
* values:         44 null
* values count:   2
~~~

<br>

* using --keypairs option 
~~~
> julia urlx.jl -u "https://admin:1234@auth.admin-user.company.co.com:443/dir1/dir2/file.js?id=44&status=null&log#page~11" --keypairs

id=44
status=null
log=
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
