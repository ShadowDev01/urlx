include("URL.jl")

using Test

println()

# Decoded URLs
URL1 = "https://admin:1234@auth.admin-user.company.co.com:443/work/desk/manage.js?id=#44&status=null&log#page~11<p>&test</p>"
URL2 = "https://www.dell.com/ae/business/p/inspiron-laptops?modaltarget=div&modaltype=box&modalwidth=738&ovrcolor=#000000&ovropac=50&position=center&t-template=products/product/modal_quickview.aspx#something"
URL3 = "https://www1.la.mycompany.com/content/topics/reftopic.aspx/gen/en/setrepcode?c=br&l=pt&redirect_url=http://www.dell.com/br/empresa/p/black-friday-presale?s&rep_id=7816440&rep_type=chat&s=bsd&~ck=mn"


@testset "URL Test" verbose = true begin
    # Make Object Of URLs
    url1 = URL(URL1)
    url2 = URL(URL2)
    url3 = URL(URL3)

    @testset "Raw-URL" begin
        @test url1.rawurl == URL1
        @test url2.rawurl == URL2
        @test url3.rawurl == URL3
    end

    @testset "Decoded URL" begin
        @test url1.url == URL1 |> URL_Decode |> HTML_Decode
        @test url2.url == URL2 |> URL_Decode |> HTML_Decode
        @test url3.url == URL3 |> URL_Decode |> HTML_Decode
    end

    @testset "Scheme" begin
        @test url1.scheme == "https"
        @test url1.scheme == "https"
        @test url1.scheme == "https"
    end

    @testset "Username" begin
        @test url1.username == "admin"
        @test url2.username == ""
        @test url3.username == ""
    end

    @testset "Password" begin
        @test url1.password == "1234"
        @test url2.password == ""
        @test url3.password == ""
    end

    @testset "Authenticate" begin
        @test url1.authenticate == "admin:1234"
        @test url2.authenticate == ""
        @test url3.authenticate == ""
    end

    @testset "Host" begin
        @test url1.host == "auth.admin-user.company.co.com"
        @test url2.host == "dell.com"
        @test url3.host == "www1.la.mycompany.com"
    end

    @testset "Subdomain" begin
        @test url1.subdomain == "auth.admin-user"
        @test url2.subdomain == ""
        @test url3.subdomain == "www1.la"
    end

    @testset "Domain" begin
        @test url1.domain == "company"
        @test url2.domain == "dell"
        @test url3.domain == "mycompany"
    end

    @testset "Tld" begin
        @test url1.tld == "co.com"
        @test url2.tld == "com"
        @test url3.tld == "com"
    end

    @testset "Port" begin
        @test url1.port == "443"
        @test url2.port == ""
        @test url3.port == ""
    end

    @testset "Path" begin
        @test url1.path == "/work/desk/manage.js"
        @test url2.path == "/ae/business/p/inspiron-laptops"
        @test url3.path == "/content/topics/reftopic.aspx/gen/en/setrepcode"
    end

    @testset "Directory" begin
        @test url1.directory == "/work/desk"
        @test url2.directory == "/ae/business/p"
        @test url3.directory == "/content/topics/reftopic.aspx/gen/en"
    end

    @testset "File" begin
        @test url1.file == "manage.js"
        @test url2.file == "inspiron-laptops"
        @test url3.file == "setrepcode"
    end

    @testset "File Name" begin
        @test url1.file_name == "manage"
        @test url2.file_name == "inspiron-laptops"
        @test url3.file_name == "setrepcode"
    end

    @testset "File Extension" begin
        @test url1.file_extension == "js"
        @test url2.file_extension == ""
        @test url3.file_extension == ""
    end

    @testset "Query" begin
        @test url1.query == "?id=#44&status=null&log"
        @test url2.query == "?modaltarget=div&modaltype=box&modalwidth=738&ovrcolor=#000000&ovropac=50&position=center&t-template=products/product/modal_quickview.aspx"
        @test url3.query == "?c=br&l=pt&redirect_url=http://www.dell.com/br/empresa/p/black-friday-presale?s&rep_id=7816440&rep_type=chat&s=bsd&~ck=mn"
    end

    @testset "Fragment" begin
        @test url1.fragment == "page~11<p>&test</p>"
        @test url2.fragment == "something"
        @test url3.fragment == ""
    end

    @testset "Query Parameters" begin
        @test url1.parameters == ["id", "status", "log"]
        @test url2.parameters == ["modaltarget", "modaltype", "modalwidth", "ovrcolor", "ovropac", "position", "t-template"]
        @test url3.parameters == ["c", "l", "redirect_url", "s", "rep_id", "rep_type", "~ck"]
    end

    @testset "Query Parameters Values" begin
        @test url1.parameters_value == ["#44", "null"]
        @test url2.parameters_value == ["div", "box", "738", "#000000", "50", "center", "products/product/modal_quickview.aspx"]
        @test url3.parameters_value == ["br", "pt", "http://www.dell.com/br/empresa/p/black-friday-presale", "7816440", "chat", "bsd", "mn"]
    end

    @testset "Query Parameters Count" begin
        @test url1.parameters_count == 3
        @test url2.parameters_count == 7
        @test url3.parameters_count == 7
    end

    @testset "Query Parameters Values Count" begin
        @test url1.parameters_value_count == 2
        @test url2.parameters_value_count == 7
        @test url3.parameters_value_count == 7
    end

end

println("\n------------------------------------------\n")

@testset "URL Decode Test" verbose = true begin
    @testset "Once URL Encoded" verbose = true begin
        # URL Encoded URLs
        EURL1_1 = "https%3a%2f%2fadmin%3a1234%40auth.admin-user.company.co.com%3a443%2fwork%2fdesk%2fmanage.js%3fid%3d%2344%26status%3dnull%26log%23page~11%3cp%3e%26test%3c%2fp%3e"
        EURL1_2 = "%68%74%74%70%73%3a%2f%2f%61%64%6d%69%6e%3a%31%32%33%34%40%61%75%74%68%2e%61%64%6d%69%6e%2d%75%73%65%72%2e%63%6f%6d%70%61%6e%79%2e%63%6f%2e%63%6f%6d%3a%34%34%33%2f%77%6f%72%6b%2f%64%65%73%6b%2f%6d%61%6e%61%67%65%2e%6a%73%3f%69%64%3d%23%34%34%26%73%74%61%74%75%73%3d%6e%75%6c%6c%26%6c%6f%67%23%70%61%67%65%7e%31%31%3c%70%3e%26%74%65%73%74%3c%2f%70%3e"

        EURL2_1 = "https%3a%2f%2fwww.dell.com%2fae%2fbusiness%2fp%2finspiron-laptops%3fmodaltarget%3ddiv%26modaltype%3dbox%26modalwidth%3d738%26ovrcolor%3d%23000000%26ovropac%3d50%26position%3dcenter%26t-template%3dproducts%2fproduct%2fmodal_quickview.aspx%23something"
        EURL2_2 = "%68%74%74%70%73%25%33%61%25%32%66%25%32%66%77%77%77%2e%64%65%6c%6c%2e%63%6f%6d%25%32%66%61%65%25%32%66%62%75%73%69%6e%65%73%73%25%32%66%70%25%32%66%69%6e%73%70%69%72%6f%6e%2d%6c%61%70%74%6f%70%73%25%33%66%6d%6f%64%61%6c%74%61%72%67%65%74%25%33%64%64%69%76%25%32%36%6d%6f%64%61%6c%74%79%70%65%25%33%64%62%6f%78%25%32%36%6d%6f%64%61%6c%77%69%64%74%68%25%33%64%37%33%38%25%32%36%6f%76%72%63%6f%6c%6f%72%25%33%64%25%32%33%30%30%30%30%30%30%25%32%36%6f%76%72%6f%70%61%63%25%33%64%35%30%25%32%36%70%6f%73%69%74%69%6f%6e%25%33%64%63%65%6e%74%65%72%25%32%36%74%2d%74%65%6d%70%6c%61%74%65%25%33%64%70%72%6f%64%75%63%74%73%25%32%66%70%72%6f%64%75%63%74%25%32%66%6d%6f%64%61%6c%5f%71%75%69%63%6b%76%69%65%77%2e%61%73%70%78%25%32%33%73%6f%6d%65%74%68%69%6e%67"

        EURL3_1 = "https%3a%2f%2fwww1.la.mycompany.com%2fcontent%2ftopics%2freftopic.aspx%2fgen%2fen%2fsetrepcode%3fc%3dbr%26l%3dpt%26redirect_url%3dhttp%3a%2f%2fwww.dell.com%2fbr%2fempresa%2fp%2fblack-friday-presale%3fs%26rep_id%3d7816440%26rep_type%3dchat%26s%3dbsd%26~ck%3dmn"
        EURL3_2 = "%68%74%74%70%73%3a%2f%2f%77%77%77%31%2e%6c%61%2e%6d%79%63%6f%6d%70%61%6e%79%2e%63%6f%6d%2f%63%6f%6e%74%65%6e%74%2f%74%6f%70%69%63%73%2f%72%65%66%74%6f%70%69%63%2e%61%73%70%78%2f%67%65%6e%2f%65%6e%2f%73%65%74%72%65%70%63%6f%64%65%3f%63%3d%62%72%26%6c%3d%70%74%26%72%65%64%69%72%65%63%74%5f%75%72%6c%3d%68%74%74%70%3a%2f%2f%77%77%77%2e%64%65%6c%6c%2e%63%6f%6d%2f%62%72%2f%65%6d%70%72%65%73%61%2f%70%2f%62%6c%61%63%6b%2d%66%72%69%64%61%79%2d%70%72%65%73%61%6c%65%3f%73%26%72%65%70%5f%69%64%3d%37%38%31%36%34%34%30%26%72%65%70%5f%74%79%70%65%3d%63%68%61%74%26%73%3d%62%73%64%26%7e%63%6b%3d%6d%6e"

        # Tests
        @test URL_Decode(EURL1_1) == URL1
        @test URL_Decode(EURL1_2) == URL1

        @test URL_Decode(EURL2_1) == URL2
        @test URL_Decode(EURL2_2) == URL2

        @test URL_Decode(EURL3_1) == URL3
        @test URL_Decode(EURL3_2) == URL3

    end

    @testset "Double URL Encoded" verbose = true begin
        # Double URL Encoded URLs
        EURL1_1 = "https%253a%252f%252fadmin%253a1234%2540auth.admin-user.company.co.com%253a443%252fwork%252fdesk%252fmanage.js%253fid%253d%252344%2526status%253dnull%2526log%2523page~11%253cp%253e%2526test%253c%252fp%253e"
        EURL1_2 = "%25%36%38%25%37%34%25%37%34%25%37%30%25%37%33%25%33%61%25%32%66%25%32%66%25%36%31%25%36%34%25%36%64%25%36%39%25%36%65%25%33%61%25%33%31%25%33%32%25%33%33%25%33%34%25%34%30%25%36%31%25%37%35%25%37%34%25%36%38%25%32%65%25%36%31%25%36%34%25%36%64%25%36%39%25%36%65%25%32%64%25%37%35%25%37%33%25%36%35%25%37%32%25%32%65%25%36%33%25%36%66%25%36%64%25%37%30%25%36%31%25%36%65%25%37%39%25%32%65%25%36%33%25%36%66%25%32%65%25%36%33%25%36%66%25%36%64%25%33%61%25%33%34%25%33%34%25%33%33%25%32%66%25%37%37%25%36%66%25%37%32%25%36%62%25%32%66%25%36%34%25%36%35%25%37%33%25%36%62%25%32%66%25%36%64%25%36%31%25%36%65%25%36%31%25%36%37%25%36%35%25%32%65%25%36%61%25%37%33%25%33%66%25%36%39%25%36%34%25%33%64%25%32%33%25%33%34%25%33%34%25%32%36%25%37%33%25%37%34%25%36%31%25%37%34%25%37%35%25%37%33%25%33%64%25%36%65%25%37%35%25%36%63%25%36%63%25%32%36%25%36%63%25%36%66%25%36%37%25%32%33%25%37%30%25%36%31%25%36%37%25%36%35%25%37%65%25%33%31%25%33%31%25%33%63%25%37%30%25%33%65%25%32%36%25%37%34%25%36%35%25%37%33%25%37%34%25%33%63%25%32%66%25%37%30%25%33%65"

        EURL2_1 = "https%253a%252f%252fwww.dell.com%252fae%252fbusiness%252fp%252finspiron-laptops%253fmodaltarget%253ddiv%2526modaltype%253dbox%2526modalwidth%253d738%2526ovrcolor%253d%2523000000%2526ovropac%253d50%2526position%253dcenter%2526t-template%253dproducts%252fproduct%252fmodal_quickview.aspx%2523something"
        EURL2_2 = "%25%36%38%25%37%34%25%37%34%25%37%30%25%37%33%25%32%35%25%33%33%25%36%31%25%32%35%25%33%32%25%36%36%25%32%35%25%33%32%25%36%36%25%37%37%25%37%37%25%37%37%25%32%65%25%36%34%25%36%35%25%36%63%25%36%63%25%32%65%25%36%33%25%36%66%25%36%64%25%32%35%25%33%32%25%36%36%25%36%31%25%36%35%25%32%35%25%33%32%25%36%36%25%36%32%25%37%35%25%37%33%25%36%39%25%36%65%25%36%35%25%37%33%25%37%33%25%32%35%25%33%32%25%36%36%25%37%30%25%32%35%25%33%32%25%36%36%25%36%39%25%36%65%25%37%33%25%37%30%25%36%39%25%37%32%25%36%66%25%36%65%25%32%64%25%36%63%25%36%31%25%37%30%25%37%34%25%36%66%25%37%30%25%37%33%25%32%35%25%33%33%25%36%36%25%36%64%25%36%66%25%36%34%25%36%31%25%36%63%25%37%34%25%36%31%25%37%32%25%36%37%25%36%35%25%37%34%25%32%35%25%33%33%25%36%34%25%36%34%25%36%39%25%37%36%25%32%35%25%33%32%25%33%36%25%36%64%25%36%66%25%36%34%25%36%31%25%36%63%25%37%34%25%37%39%25%37%30%25%36%35%25%32%35%25%33%33%25%36%34%25%36%32%25%36%66%25%37%38%25%32%35%25%33%32%25%33%36%25%36%64%25%36%66%25%36%34%25%36%31%25%36%63%25%37%37%25%36%39%25%36%34%25%37%34%25%36%38%25%32%35%25%33%33%25%36%34%25%33%37%25%33%33%25%33%38%25%32%35%25%33%32%25%33%36%25%36%66%25%37%36%25%37%32%25%36%33%25%36%66%25%36%63%25%36%66%25%37%32%25%32%35%25%33%33%25%36%34%25%32%35%25%33%32%25%33%33%25%33%30%25%33%30%25%33%30%25%33%30%25%33%30%25%33%30%25%32%35%25%33%32%25%33%36%25%36%66%25%37%36%25%37%32%25%36%66%25%37%30%25%36%31%25%36%33%25%32%35%25%33%33%25%36%34%25%33%35%25%33%30%25%32%35%25%33%32%25%33%36%25%37%30%25%36%66%25%37%33%25%36%39%25%37%34%25%36%39%25%36%66%25%36%65%25%32%35%25%33%33%25%36%34%25%36%33%25%36%35%25%36%65%25%37%34%25%36%35%25%37%32%25%32%35%25%33%32%25%33%36%25%37%34%25%32%64%25%37%34%25%36%35%25%36%64%25%37%30%25%36%63%25%36%31%25%37%34%25%36%35%25%32%35%25%33%33%25%36%34%25%37%30%25%37%32%25%36%66%25%36%34%25%37%35%25%36%33%25%37%34%25%37%33%25%32%35%25%33%32%25%36%36%25%37%30%25%37%32%25%36%66%25%36%34%25%37%35%25%36%33%25%37%34%25%32%35%25%33%32%25%36%36%25%36%64%25%36%66%25%36%34%25%36%31%25%36%63%25%35%66%25%37%31%25%37%35%25%36%39%25%36%33%25%36%62%25%37%36%25%36%39%25%36%35%25%37%37%25%32%65%25%36%31%25%37%33%25%37%30%25%37%38%25%32%35%25%33%32%25%33%33%25%37%33%25%36%66%25%36%64%25%36%35%25%37%34%25%36%38%25%36%39%25%36%65%25%36%37"

        EURL3_1 = "https%253a%252f%252fwww1.la.mycompany.com%252fcontent%252ftopics%252freftopic.aspx%252fgen%252fen%252fsetrepcode%253fc%253dbr%2526l%253dpt%2526redirect_url%253dhttp%253a%252f%252fwww.dell.com%252fbr%252fempresa%252fp%252fblack-friday-presale%253fs%2526rep_id%253d7816440%2526rep_type%253dchat%2526s%253dbsd%2526~ck%253dmn"
        EURL3_2 = "%25%36%38%25%37%34%25%37%34%25%37%30%25%37%33%25%33%61%25%32%66%25%32%66%25%37%37%25%37%37%25%37%37%25%33%31%25%32%65%25%36%63%25%36%31%25%32%65%25%36%64%25%37%39%25%36%33%25%36%66%25%36%64%25%37%30%25%36%31%25%36%65%25%37%39%25%32%65%25%36%33%25%36%66%25%36%64%25%32%66%25%36%33%25%36%66%25%36%65%25%37%34%25%36%35%25%36%65%25%37%34%25%32%66%25%37%34%25%36%66%25%37%30%25%36%39%25%36%33%25%37%33%25%32%66%25%37%32%25%36%35%25%36%36%25%37%34%25%36%66%25%37%30%25%36%39%25%36%33%25%32%65%25%36%31%25%37%33%25%37%30%25%37%38%25%32%66%25%36%37%25%36%35%25%36%65%25%32%66%25%36%35%25%36%65%25%32%66%25%37%33%25%36%35%25%37%34%25%37%32%25%36%35%25%37%30%25%36%33%25%36%66%25%36%34%25%36%35%25%33%66%25%36%33%25%33%64%25%36%32%25%37%32%25%32%36%25%36%63%25%33%64%25%37%30%25%37%34%25%32%36%25%37%32%25%36%35%25%36%34%25%36%39%25%37%32%25%36%35%25%36%33%25%37%34%25%35%66%25%37%35%25%37%32%25%36%63%25%33%64%25%36%38%25%37%34%25%37%34%25%37%30%25%33%61%25%32%66%25%32%66%25%37%37%25%37%37%25%37%37%25%32%65%25%36%34%25%36%35%25%36%63%25%36%63%25%32%65%25%36%33%25%36%66%25%36%64%25%32%66%25%36%32%25%37%32%25%32%66%25%36%35%25%36%64%25%37%30%25%37%32%25%36%35%25%37%33%25%36%31%25%32%66%25%37%30%25%32%66%25%36%32%25%36%63%25%36%31%25%36%33%25%36%62%25%32%64%25%36%36%25%37%32%25%36%39%25%36%34%25%36%31%25%37%39%25%32%64%25%37%30%25%37%32%25%36%35%25%37%33%25%36%31%25%36%63%25%36%35%25%33%66%25%37%33%25%32%36%25%37%32%25%36%35%25%37%30%25%35%66%25%36%39%25%36%34%25%33%64%25%33%37%25%33%38%25%33%31%25%33%36%25%33%34%25%33%34%25%33%30%25%32%36%25%37%32%25%36%35%25%37%30%25%35%66%25%37%34%25%37%39%25%37%30%25%36%35%25%33%64%25%36%33%25%36%38%25%36%31%25%37%34%25%32%36%25%37%33%25%33%64%25%36%32%25%37%33%25%36%34%25%32%36%25%37%65%25%36%33%25%36%62%25%33%64%25%36%64%25%36%65"

        # Tests
        @test URL_Decode(EURL1_1) == URL1
        @test URL_Decode(EURL1_2) == URL1

        @test URL_Decode(EURL2_1) == URL2
        @test URL_Decode(EURL2_2) == URL2

        @test URL_Decode(EURL3_1) == URL3
        @test URL_Decode(EURL3_2) == URL3
    end

    @testset "Multiple URL Encoded" verbose = true begin
        # Multiple (4 times) URL Encoded URLs
        EURL1_1 = "https%2525253a%2525252f%2525252fadmin%2525253a1234%25252540auth.admin-user.company.co.com%2525253a443%2525252fwork%2525252fdesk%2525252fmanage.js%2525253fid%2525253d%2525252344%25252526status%2525253dnull%25252526log%25252523page~11%2525253cp%2525253e%25252526test%2525253c%2525252fp%2525253e"

        # Tests
        @test URL_Decode(EURL1_1) == URL1
    end
end

println("\n------------------------------------------\n")

@testset "HTML Decode Test" verbose = true begin
    @testset "HTML HEX/DEC Encoded" verbose = true begin
        # HTML Encoded URLs
        EURL1_1 = "&#x68;&#x74;&#x74;&#x70;&#x73;&#x3a;&#x2f;&#x2f;&#x61;&#x64;&#x6d;&#x69;&#x6e;&#x3a;&#x31;&#x32;&#x33;&#x34;&#x40;&#x61;&#x75;&#x74;&#x68;&#x2e;&#x61;&#x64;&#x6d;&#x69;&#x6e;&#x2d;&#x75;&#x73;&#x65;&#x72;&#x2e;&#x63;&#x6f;&#x6d;&#x70;&#x61;&#x6e;&#x79;&#x2e;&#x63;&#x6f;&#x2e;&#x63;&#x6f;&#x6d;&#x3a;&#x34;&#x34;&#x33;&#x2f;&#x77;&#x6f;&#x72;&#x6b;&#x2f;&#x64;&#x65;&#x73;&#x6b;&#x2f;&#x6d;&#x61;&#x6e;&#x61;&#x67;&#x65;&#x2e;&#x6a;&#x73;&#x3f;&#x69;&#x64;&#x3d;&#x23;&#x34;&#x34;&#x26;&#x73;&#x74;&#x61;&#x74;&#x75;&#x73;&#x3d;&#x6e;&#x75;&#x6c;&#x6c;&#x26;&#x6c;&#x6f;&#x67;&#x23;&#x70;&#x61;&#x67;&#x65;&#x7e;&#x31;&#x31;&#x3c;&#x70;&#x3e;&#x26;&#x74;&#x65;&#x73;&#x74;&#x3c;&#x2f;&#x70;&#x3e;"

        # Tests
        @test HTML_Decode(EURL1_1) == URL1
        @test HTML_Decode("&#x3c;&#x70;&#x3e;&#x22;&#x6d;&#x65;&#x22;&#x26;&#x27;&#x79;&#x6f;&#x75;&#x27;&#x3c;&#x2f;&#x70;&#x3e;") == """<p>"me"&'you'</p>"""
    end

    @testset "HTML Symbol Encoded" verbose = true begin
        # HTML Encoded URLs
        EURL1_1 = "https://admin:1234@auth.admin-user.company.co.com:443/work/desk/manage.js?id=#44&amp;status=null&amp;log#page~11&lt;p&gt;&amp;test&lt;/p&gt;"

        # Tests
        @test HTML_Decode(EURL1_1) == URL1
        @test HTML_Decode("""&lt;p&gt;&quot;me&quot;&amp;&apos;you&apos;&lt;/p&gt;""") == """<p>"me"&'you'</p>"""
        @test HTML_Decode("""&LT;p&GT;&QUOT;me&QUOT;&AMP;&APOS;you&APOS;&LT;/p&GT;""") == """<p>"me"&'you'</p>"""
    end

    @testset "Double HTML Encoded" verbose = true begin
        # Double HTML HEX/DEC Encoded
        @test HTML_Decode("&#x26;&#x23;&#x78;&#x33;&#x63;&#x3b;&#x26;&#x23;&#x78;&#x37;&#x30;&#x3b;&#x26;&#x23;&#x78;&#x33;&#x65;&#x3b;&#x26;&#x23;&#x78;&#x32;&#x32;&#x3b;&#x26;&#x23;&#x78;&#x36;&#x64;&#x3b;&#x26;&#x23;&#x78;&#x36;&#x35;&#x3b;&#x26;&#x23;&#x78;&#x32;&#x32;&#x3b;&#x26;&#x23;&#x78;&#x32;&#x36;&#x3b;&#x26;&#x23;&#x78;&#x32;&#x37;&#x3b;&#x26;&#x23;&#x78;&#x37;&#x39;&#x3b;&#x26;&#x23;&#x78;&#x36;&#x66;&#x3b;&#x26;&#x23;&#x78;&#x37;&#x35;&#x3b;&#x26;&#x23;&#x78;&#x32;&#x37;&#x3b;&#x26;&#x23;&#x78;&#x33;&#x63;&#x3b;&#x26;&#x23;&#x78;&#x32;&#x66;&#x3b;&#x26;&#x23;&#x78;&#x37;&#x30;&#x3b;&#x26;&#x23;&#x78;&#x33;&#x65;&#x3b;") == """<p>"me"&'you'</p>"""

        # Double HTML Symbol Encoded
        @test HTML_Decode("""&amp;lt;p&amp;gt;&amp;quot;me&amp;quot;&amp;amp;&amp;apos;you&amp;apos;&amp;lt;/p&amp;gt;""") == """<p>"me"&'you'</p>"""
    end
end

println("\n------------------------------------------\n")

@testset "Split Host Tests" verbose = true begin
    @test split_domain("auth.admin-user.company.co.com") == ("auth.admin-user", "company", "co.com")
    @test split_domain("www1.la.mycompany.com") == ("www1.la", "mycompany", "com")
    @test split_domain("www.dell.com") == ("www", "dell", "com")
end

println("\n------------------------------------------\n")

@testset "Split File Name/Extension" verbose = true begin
    @test split_file("master.php") == ["master", "php"]
    @test split_file("admin-login.js") == ["admin-login", "js"]
    @test split_file("Desktop") == ["Desktop", ""]
    @test split_file("Photo.png.png") == ["Photo", "png.png"]
end

println("\n------------------------------------------\n")

@testset "Query Parameters" verbose = true begin
    @test QueryParams("?c=ae&l=ar&s=dhs") == ["c", "l", "s"]
    @test QueryParams("?s=bsd&t-template=products/category/franchegory_ice.aspx&~ck=mn") == ["s", "t-template", "~ck"]
    @test QueryParams("?c=cl&cid=621&cs=cldhs1&dgc=SM&l=es&lid=spr7315928050&linkId=176697242&refid=sm_TWITTER_spr7315928050&s=dhs&~ck=mn") == ["c", "cid", "cs", "dgc", "l", "lid", "linkId", "refid", "s", "~ck"]
    @test QueryParams("?a=51808~0~812592,55846~0~879657,51795~0~812537,55103~0~857204,54733~0~852726&method=nav&navValc=Intel Core 2 Duo&navidc=Processor&navla=55103~0~857204&page=1&qt=anav&subcats&~ck=anav") == ["a", "method", "navValc", "navidc", "navla", "page", "qt", "subcats", "~ck"]
end

println("\n------------------------------------------\n")

@testset "Query Parameters Values" verbose = true begin
    @test QueryParamsValues("?c=ae&l=ar&s=dhs") == ["ae", "ar", "dhs"]
    @test QueryParamsValues("?s=bsd&t-template=products/category/franchegory_ice.aspx&~ck=mn") == ["bsd", "products/category/franchegory_ice.aspx", "mn"]
    @test QueryParamsValues("?c=cl&cid=621&cs=cldhs1&dgc=SM&l=es&lid=spr7315928050&linkId=176697242&refid=sm_TWITTER_spr7315928050&s=dhs&~ck=mn") == ["cl", "621", "cldhs1", "SM", "es", "spr7315928050", "176697242", "sm_TWITTER_spr7315928050", "dhs", "mn"]
    @test QueryParamsValues("?a=51808~0~812592,55846~0~879657,51795~0~812537,55103~0~857204,54733~0~852726&method=nav&navValc=Intel Core 2 Duo&navidc=Processor&navla=55103~0~857204&page=1&qt=anav&subcats&~ck=anav") == ["51808~0~812592,55846~0~879657,51795~0~812537,55103~0~857204,54733~0~852726", "nav", "Intel", "Processor", "55103~0~857204", "1", "anav"]
end