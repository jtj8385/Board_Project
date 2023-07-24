<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>게시글 상세보기</title>
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
    <section>
        <div class="content">
            <div class="write-form">
                <div class="user-info">
                    <div class="user-info-sub">
                        <p>등급 [${mb.g_name}]</p>
                        <p>POINT [${mb.m_point}]</p>
                    </div>
                </div>
                <h2 class="login-header">상세보기</h2>
                <div>
                    <div class="t_content p-15">NUM</div>
                    <div class="d_content p-85">${board.b_num}</div>
                </div>
                <div>
                    <div class="t_content p-15">WRITER</div>
                    <div class="d_content p-35">${board.m_name}</div>
                    <div class="t_content p-15">DATE</div>
                    <div class="d_content p-35">
                        <fmt:formatDate value="${board.b_date}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate>
                    </div>
                </div>
                <div>
                    <div class="t_content p-15">TITLE</div>
                    <div class="d_content p-85">${board.b_title}</div>
                </div>
                <div>
                    <div class="t_content p-15 content_h">CONTENTS</div>
                    <div class="d_content p-85 content_h">${board.b_contents}</div>
                </div>
                <div>
                    <div class="t_content p-15 file_h">FILES</div>
                    <div class="d_content p-85 file_h" style="overflow: auto;">
                        <c:if test="${empty fList}">
                            첨부된 파일이 없습니다.
                        </c:if>
                        <c:if test="${!empty fList}">
                            <c:forEach var="fitem" items="${fList}">
                                <a href="/download?bf_sysname=${fitem.bf_sysname}&bf_oriname=${fitem.bf_oriname}">
                                    <span class="file-title">
                                            ${fitem.bf_oriname}
                                    </span>
                                </a>
                            </c:forEach>
                        </c:if>
                    </div>
                    <div class="btn-area">
                        <button class="btn-write" id="upbtn" onclick="upboard('${board.b_num}')">U</button>
                        <button class="btn-write" id="delbtn" onclick="delCheck('${board.b_num}')">D</button>
                        <button class="btn-sub" onclick="backbtn()">B</button>
                    </div>
                    <!-- 댓글 입력 양식-->
                    <form id="rform">
                        <!-- 게시글정보(글번호), 댓글 내용, 잡속자(작성자) -->
                        <input type="hidden" name="r_bnum" value="${board.b_num}">
                        <textarea rows="3" class="write-input ta" name="r_contents"
                                  id="comment" placeholder="댓글을 작성해주세요."></textarea>
                        <input type="hidden" name="r_id" value="${mb.m_id}">
                        <input type="button" value="댓글 작성" class="btn-write"
                               onclick="replyInsert()" style="width: 100%; margin-bottom: 30px;">
                    </form>

                    <table style="width: 100%"><!--제목 테이블-->
                        <tr class="rtbl-head">
                            <td class="p-20">Writer</td>
                            <td class="p-50">Contents</td>
                            <td class="p-30">Date</td>
                            </tr>
                    </table>
                    <table style="width: 100%" id="rtable">
                        <c:forEach var="ritem" items="${rList}">
                            <tr>
                                <td class="p-20">${ritem.r_id}</td>
                                <td class="p-50">${ritem.r_contents}</td>
                                <td class="p-30">
                                    <fmt:formatDate value="${ritem.r_date}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
        </div>
    </section>
    <footer>
        <jsp:include page="footer.jsp"></jsp:include>
    </footer>
</div>
</body>
<script>
    //수정 ,삭제 버튼 처리(글작성자가 아니면 버튼 숨기기)
    $("#upbtn").hide();
    $("#delbtn").hide();
    let mid = "${mb.m_id}";
    let bid = "${board.b_id}";

    if (mid == bid){
        $("#upbtn").show();
        $("#delbtn").show();
    }

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

    function replyInsert(){
        //form에 작성한 내용 가져와서 serialize
        const replyForm = $("#rform").serialize();
        console.log(replyForm);

        //controller에 전송(ajax)
        $.ajax({
           url: "replyInsert",
           type: "post",
           data: replyForm,
           success: function (res) {
               console.log(res);
               let str = "";
               str += "<tr>" + "<td class='p-20'>" + res.r_id + "</td>"
                            + "<td class='p-50'>" + res.r_contents + "</td>"
                            + "<td class='p-30'>" + res.r_date + "</td>" + "</tr>";

               $("#rtable").prepend(str);//첫번째 위치에 댓글 삽입
               $("#comment").val("");//작성완료후 댓글 입력창의 내용 지우기
               alert("댓글 작성 성공");
           },
            error: function (err){
               console.log(err);
               alert("댓글 작성 실패");
                $("#comment").val("");
                $("#comment").focus();
            }
        });
    }

    function delCheck(bnum){
        //상세 화면으로 보이는 게시글을 삭제(글번호로 삭제)
        //alert(bnum);
        let conf = confirm("삭제하시겠습니까?");
        if (conf == true){
            location.href = "/delete?b_num=" + bnum;
        }
    }

    function upboard(bnum){
        location.href = "/updateForm?b_num=" + bnum;
    }
</script>
</html>
