<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<style>
	.RESTDAY {color : red!important;}
	.SATDAY {color : blue!important;}
	</style>
	
    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출

            $a.page.setEventListener();
            $a.page.setGrid1();
            $a.page.setGrid2();
            $("#CNSL_DT").val(getCurrdate().substr(0,7));
        },
        setEventListener : function() {
        	$("#btnSearch").click(function(){
        		if ( ! $.PSNM.isValid("#searchForm") ) {
    			    return false; //값 검증
    			}
        		$a.page.searchList();
        	});
        },
        setGrid1 : function() {
            $("#grid1").alopexGrid({
            	pager : false,
            	rowClickSelect : false,
                height : "300px",
                columnMapping : [
					{ columnIndex : 0, key : "SUN",	title : "일",	align : "center", 	width : "80px", tooltip : false
                   		, render : function(value, data) {
                    		return value;
                    	}
                    },
                    { columnIndex : 1, key : "MON",	title : "월",	align : "center", 	width : "80px", tooltip : false
                    	, render : function(value, data) {
                    		return value;
                    	}
                    },
                    { columnIndex : 2, key : "TUE",	title : "화",	align : "center", 	width : "80px", tooltip : false
                    	, render : function(value, data) {
                    		return value;
                    	}
                    },
                    { columnIndex : 3, key : "WED",	title : "수",	align : "center", 	width : "80px", tooltip : false
                    	, render : function(value, data) {
                    		return value;
                    	}
                    },
                    { columnIndex : 4, key : "THU",	title : "목",	align : "center", 	width : "80px", tooltip : false
                    	, render : function(value, data) {
                    		return value;
                    	}
                    },
                    { columnIndex : 5, key : "FRI",	title : "금",	align : "center", 	width : "80px", tooltip : false
                    	, render : function(value, data) {
                    		return value;
                    	}
                    },
                    { columnIndex : 6, key : "SAT",	title : "토",	align : "center", 	width : "80px", tooltip : false
                    	, render : function(value, data) {
                    		return value;
                    	}
                    }
                ]
            });
            $("#grid1").alopexGrid('updateOption', {
				message : { nodata : "" }
            });
        },
        setGrid2 : function() {
            $("#grid2").alopexGrid({
            	pager : false,
            	rowClickSelect : false,
                height : "100px",
                columnMapping : [
                    { columnIndex : 0, key : "TT_CNT",		title : "총 시행횟수",	align : "center", 	width : "80px"	},
                    { columnIndex : 1, key : "R_CNT",		title : "정기면담",		align : "center", 	width : "80px"  },
                    { columnIndex : 2, key : "T_CNT",		title : "수시면담",		align : "center", 	width : "80px" 	},
                    { columnIndex : 3, key : "TEAM_CNT",	title : "팀장",			align : "center", 	width : "80px"	},
                    { columnIndex : 4, key : "DEPT_CNT",	title : "국장",			align : "center", 	width : "80px" 	}
                ]
            });
            $("#grid2").alopexGrid('updateOption', {
				message : { nodata : "" }
            });
        },
        searchList: function(param) {
        	
            $.alopex.request("biz.AGNTFTFT@PAGENTCNSLPRSS001_pSearchAgentCnslPrss", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.CNSL_DT   = $.PSNMUtils.getDateInput("CNSL_DT");
                }],
                success: function(res) {
					var gridList = res.dataSet.recordSets;
					
                    $.each(gridList, function(key, data) {
                    	$("#"+key).alopexGrid("dataSet", data.nc_list);
                    });
                }
            });
        }
    });

    </script>
    
</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- contents area -->
<div id="contents">

	<!-- sub title area -->
    <div class="content_title">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">면담현황</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">영업국업무</span> <span class="a3"> > </span> <span class="a4"><b>에이전트관리</b></span>
                </span> 
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm" onsubmit="return false;">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:12%"/>
	            <col style="width:21%"/>
	            <col style="width:12%"/>
	            <col style="width:21%"/>
	            <col style="width:12%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
                <th scope="col" class="fontred">시행월</th>
                <td class="tleft">
					<input id="CNSL_DT" name="CNSL_DT" data-type="dateinput" data-pickertype="monthly" data-bind="value:CNSL_DT" style="width:60px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"/>
				</td>
				<th class="fontred">본사팀</th>
				<td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" 
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th class="fontred">본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" 
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th class="fontred">영업국명</th>
				<td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" 
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['영업국명'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
				<th>영업팀명</th>
				<td class="tleft" colspan="3">
                    <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" >
                    	<option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
        </form>
    </div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>월별 면담 진행 현황</b></div>
    <!-- main grid -->
    <div id="grid1" data-bind="grid:grid1"></div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>면담유형별/ 직책별 진행 현황</b></div>
    <div id="grid2" data-bind="grid:grid2"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>