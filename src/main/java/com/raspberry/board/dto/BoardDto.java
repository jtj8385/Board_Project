package com.raspberry.board.dto;

import lombok.Data;

import java.sql.Timestamp;

//게시판 목록 처리
@Data
public class BoardDto {
    private int b_num;
    private String b_title;
    private String b_contents;
    private String b_id;
    private String m_name;
    private Timestamp b_date;
    private int b_views;
}
