package com.raspberry.board.dto;

import lombok.Data;

@Data
//파일 업로드를 위한 DTO
public class BfileDto {
    private int bf_bnum;
    private String bf_oriname;
    private String bf_sysname;
}
