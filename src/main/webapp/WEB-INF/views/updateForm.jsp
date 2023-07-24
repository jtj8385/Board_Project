<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>글 수정</title>
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
            <form action="updateProc" class="write-form" method="post" enctype="multipart/form-data">
                <div class="user-info">
                    <div class="user-info-sub">
                        <p>등급 [${mb.g_name}]</p>
                        <p>POINT [${mb.m_point}]</p>
                    </div>
                </div>
                <h2 class="login-header">글수정</h2>
                <!-- 로그인한 id(숨김), 제목, 내용, 파일-->
                <input type="hidden" name="b_id" value="${mb.m_id}">
                <input type="hidden" name="b_num" value="${board.b_num}">
                <input type="text" class="write-input" name="b_title"
                       autofocus placeholder="제목 입력" required value="${board.b_title}">
                <textarea rows="15" name="b_contents" placeholder="내용 입력"
                          class="write-input ta">${board.b_contents}</textarea>
                <div class="filebox">
                    <!-- 첨부된 파일 목록 출력-->
                    <div id="bfile" style="margin-bottom: 10px;">
                        <c:if test="${empty fList}">
                            <label style="width: 100%;">첨부파일 없음</label>
                        </c:if>
                        <c:if test="${!empty fList}">
                            <c:forEach var="f" items="${fList}">
                                <label style="width: 100%;" onclick="del('${f.bf_sysname}')">
                                    ${f.bf_oriname}
                                </label>
                            </c:forEach>
                        </c:if>
                    </div>
                    <!--새로운 파일 첨부-->
                    <label for="file">파일 추가</label>
                    <input type="file" name="files" id="file" multiple>
                    <input type="text" class="upload-name" value="파일 선택" readonly>
                </div>
                <div class="btn-area">
                    <input type="submit" class="btn-write" value="U">
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
        location.href = "/contents?b_num=${board.b_num}";
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

    function del(sysname) {
        //alert(sysname);
        let con = confirm("파일을 삭제하시겠습니까?");

        if (con == true){
            let objdata = {"sysname":sysname};
            //파일 목록을 다시 불러오기 위해 게시글 번호 추가
            objdata.bnum = ${board.b_num};
            console.log(objdata);

            $.ajax({
                url: "delFile",
                type: "post",
                data: objdata,
                success: function (res){
                    console.log(res);
                    console.log(res.length);
                    let flist = "";
                    if (res.length == 0){
                        flist += '<label style="width: 100%;">첨부파일 없음</label>';
                    } else {
                        for (let f of res){
                            flist += '<label style="width: 100%;" onclick="del(\''
                                + f.bf_sysname + '\')">'
                                + f.bf_oriname + '</label>';
                        }
                    }
                    $("#bfile").html(flist);
                    alert("파일 삭제가 완료되었습니다.")
                },
                error: function (err){
                    console.log(err);
                    alert("삭제를 실패하였습니다.")
                }
            });
        }
    }

</script>
</html>
