<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>글쓰기 페이지</title>
    <script src="js/jquery-3.7.0.min.js"></script>
    <link rel="stylesheet" href="css/style.css">
    <script>
        $(function(){
            //메시지 출력 부분
            let m = "${msg}";
            if(m != ""){
                alert(m);
            }

            //로그인한 회원 정보 및 로그아웃 출력
            let loginName = "${mb.m_name}";
            $("#mname").html(loginName + "님");
            $(".suc").css("display", "block");
            $(".bef").css("display", "none");
        });
    </script>
</head>
<body>
<div class="wrap">
    <header>
        <jsp:include page="header.jsp"></jsp:include>
    </header>
    <sectione>
        <div class="content">
            <form action="writeProc" class="write-form" method="post" enctype="multipart/form-data">
                <div class="user-info">
                    <div class="user-info-sub">
                        <p>등급 [${mb.g_name}]</p>
                        <p>POINT [${mb.m_point}]</p>
                    </div>
                </div>
                <h2 class="login-header">글쓰기</h2>
                <!-- 로그인한 id(숨김), 제목, 내용, 파일-->
                <input type="hidden" name="b_id" value="${mb.m_id}">
                <input type="text" class="write-input" name="b_title"
                        autofocus placeholder="제목 입력" required>
                <textarea rows="15" name="b_contents" placeholder="내용 입력"
                        class="write-input ta"></textarea>
                <div class="filebox">
                    <label for="file">업로드</label>
                    <input type="file" name="files" id="file" multiple>
                    <input type="text" class="upload-name" value="파일 선택" readonly>
                </div>
                <div class="btn-area">
                    <input type="submit" class="btn-write" value="W">
                    <input type="reset" class="btn-write" value="R">
                    <input type="button" class="btn-write" value="B" onclick="backbtn()">
                </div>
            </form>
        </div>
    </sectione>
    <footer>
        <jsp:include page="footer.jsp"></jsp:include>
    </footer>
</div>
</body>
<script>
    function backbtn(){
        let urlstr = "/list?";
        let col = "${sdto.colname}";
        let keyw = "${sdto.keyword}";

        if (col == null || col == ""){ //검색을 수행하지 않은 경우
            urlstr += "pageNum=${pageNum}";
        } else {
            urlstr += "colname=${sdto.colname}" +
                        "&keyword=${sdto.keyword}" +
                        "&pageNum=${pageNum}";
        }
        //console.log(urlstr);
        location.href = urlstr;
    }

    //파일 제목 처리용 함수
    $("#file").on("change",function (){
       //파일 선택창에서 업로드할 파일을 선택한 후 '열기' 버튼을 누르면 change이벤트가 발생
        console.log($("#file"));

        let files = $("#file")[0].files;
        console.log(files);

        let fileName = "";
        if (files.length > 1){ //하나 이상의 파일 업로드할 때
            fileName = files[0].name + " 외 " + (files.length - 1) + "개";
        }else if (files.length == 1){ //파일 하나만 업로드 할 때
            fileName = files[0].name;
        } else { //파일이 업로드하지 않을 때
            fileName = "파일 선택";
        }
        $(".upload-name").val(fileName);
    });
</script>
</html>
