package com.raspberry.board.dto;

import lombok.Data;

@Data
public class SearchDto {
    private String colname;
    private String keyword;
    private int pageNum; //보여질 페이지 번호
    private int listCnt; //페이지당 출력할 게시글 개수
}
