FROM julia:1.9.2
RUN julia -e 'using Pkg; Pkg.add("ArgParse"); Pkg.add("JSON"); Pkg.add("OrderedCollections")'
RUN mkdir /urlx
WORKDIR /urlx/
COPY . /urlx/
ENTRYPOINT [ "julia", "/urlx/urlx.jl" ]
CMD [ "-h" ]