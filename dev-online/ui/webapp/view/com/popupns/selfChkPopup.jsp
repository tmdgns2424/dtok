<%
	response.setHeader("Pragma","no-cache");			// HTTP1.0 ĳ�� ����
	response.setDateHeader("Expires",0);				// proxy ������ ĳ�� ����
	response.setHeader("Pragma", "no-store");			// HTTP1.1 ĳ�� ����
	if(request.getProtocol().equals("HTTP/1.1"))
	response.setHeader("Cache-Control", "no-cache");    // HTTP1.1 ĳ�� ����
%>
<%@ page contentType="text/html; charset=ksc5601" %>
<%@ page import = "java.util.*, java.text.SimpleDateFormat, nexcore.framework.core.util.BaseUtils, com.icert.comm.secu.IcertSecuManager"%> 
<%	//��¥ ����
	Calendar today = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
	String day = sdf.format(today.getTime());

	java.util.Random ran = new Random();
	//���� ���� ����
	int numLength = 6;
	String randomStr = "";
    
	for (int i = 0; i < numLength; i++) {
	    //0 ~ 9 ���� ���� ����
	    randomStr += ran.nextInt(10);
	}	
	System.out.println("**********************************************************************************************");
    String tr_cert   = "";
    String cpId      = BaseUtils.getConfiguration("phone.certi.svc.id");            // ���νǸ�Ȯ�� ȸ���� ���̵�
    String urlCode   = BaseUtils.getConfiguration("phone.certi.svc.srvNo");         // ���νǸ�Ȯ�� urlCode
  	//reqNum�� �ִ� 40byte ���� ��� ����
    String certNum   = day + randomStr;                                     // ���νǸ�Ȯ�� ��û��ȣ
    String date  	 = day;                                                 // ���νǸ�Ȯ�� ��û�ð�
    String certMet   = "M";                                                 // �����������
    String name          = "";        // ����
    String phoneNo	     = "";	    // �޴�����ȣ
    String phoneCorp     = "";   // �̵���Ż�
	String birthDay	     = "";	// �������
	String gender	     = "";		// ����
    String nation        = "";      // ���ܱ��� ����
	String plusInfo      = "";	// �߰�DATA����
    String extendVar = "0000000000000000";                                   // ��ȣȭ�� �ӽ��ʵ�
    String tr_url    = BaseUtils.getConfiguration("dtok.domain") + request.getContextPath() + "/view/com/popupns/selfChkRtnPopup.jsp?certNum=" + certNum;  // ���νǸ�Ȯ�� ������� URL
    //String tr_url   = "32" + TrmsUtils.getPath( "/jsp/trms/pop/userCerticificaionResult.jsp" );  // ���νǸ�Ȯ�� ������� URL
	
	//String certGb	= "H";                                       // ���νǸ�Ȯ�� ����Ȯ�� ��������:�ڵ���
	//String addVar	= request.getParameter("addVar");                           // ���νǸ�Ȯ�� �߰� �Ķ����

	/** certNum ���ǻ��� **************************************************************************************
	* 1. �������� ����� ��ȣȭ�� ���� Ű�� Ȱ��ǹǷ� �߿���.
	* 2. �������� ��û�� �ߺ����� �ʰ� �����ؾ���. (��-��������ȣ)
	* 3. certNum���� �������� ����� ���� �� ��ȣȭŰ�� �����.
	       tr_url���� certNum���� �����ؼ� �����ϰ�, (tr_url = tr_url + "?certNum=" + certNum;)
		   tr_url���� ������Ʈ�� ���·� certNum���� ������ ��. (certNum = request.getParameter("certNum"); )
	*
	***********************************************************************************************************/
	
	//01. �ѱ����������(��) ��ȣȭ ��� ����
	IcertSecuManager seed  = new IcertSecuManager();
	
	//02. 1�� ��ȣȭ (tr_cert �����ͺ��� ���� �� ��ȣȭ)
	String enc_tr_cert = "";
	tr_cert            = cpId +"/"+ urlCode +"/"+ certNum +"/"+ date +"/"+ certMet +"/"+ birthDay +"/"+ gender +"/"+ name +"/"+ phoneNo +"/"+ phoneCorp +"/"+ nation +"/"+ plusInfo +"/"+ extendVar;
	enc_tr_cert        = seed.getEnc(tr_cert, "");
	
	//03. 1�� ��ȣȭ �����Ϳ� ���� ������ ������ ���� (HMAC)
	String hmacMsg = "";
	hmacMsg = seed.getMsg(enc_tr_cert);
	
	//04. 2�� ��ȣȭ (1�� ��ȣȭ ������, HMAC ������, extendVar ���� �� ��ȣȭ)
	tr_cert  = seed.getEnc(enc_tr_cert + "/" + hmacMsg + "/" + extendVar, "");
	
	/*
	Cookie c = new Cookie("reqNum", reqNum);
	//c.setMaxAge(1800);  // <== �ʿ�� ����(�ʴ����� �����˴ϴ�)
	response.addCookie(c);

    //01. ��ȣȭ ��� ����
	com.sci.v2.pcc.secu.SciSecuManager seed  = new com.sci.v2.pcc.secu.SciSecuManager();

	//02. 1�� ��ȣȭ
	String encStr = "";
	String tr_cert      = id+"^"+srvNo+"^"+reqNum+"^"+certDate+"^"+certGb+"^"+addVar+"^"+exVar;  // ������ ��ȣȭ
	encStr              = seed.getEncPublic(reqInfo);

	//03. ������ ���� �� ����
	com.sci.v2.pcc.secu.hmac.SciHmac hmac = new com.sci.v2.pcc.secu.hmac.SciHmac();
	String hmacMsg = hmac.HMacEncriptPublic(encStr);

	//03. 2�� ��ȣȭ
	reqInfo  = seed.getEncPublic(encStr + "^" + hmacMsg + "^" + "0000000000000000");  //2����ȣȭ
	*/
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<script>
    <!--
    window.name = "��������";
	var KMCIS_window;
	
	function openKMCISWindow() {		
	   var UserAgent = navigator.userAgent;
	    /* ����� ���� üũ*/
	    // ������� ��� (�������� ������� �߰� �ʿ�)
	    /*
	    if (UserAgent.match(/iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || UserAgent.match(/LG|SAMSUNG|Samsung/) != null) {
	   		 document.reqKMCISForm.target = '';
		  } else { // ������� �ƴ� ���
	   		KMCIS_window = window.open('', 'KMCISWindow', 'width=425, height=550, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=435, top=250' );

	   		if(KMCIS_window == null){
	  			alert(" �� ������ XP SP2 �Ǵ� ���ͳ� �ͽ��÷η� 7 ������� ��쿡�� \n    ȭ�� ��ܿ� �ִ� �˾� ���� �˸����� Ŭ���Ͽ� �˾��� ����� �ֽñ� �ٶ��ϴ�. \n\n�� MSN,����,���� �˾� ���� ���ٰ� ��ġ�� ��� �˾������ ���ֽñ� �ٶ��ϴ�.");
	        }
	   		
	   		document.reqKMCISForm.target = 'KMCISWindow';
		  }
		*/
		  document.reqKMCISForm.action = 'https://www.kmcert.com/kmcis/web/kmcisReq.jsp';
		  document.reqKMCISForm.submit();
	}
	//-->
</script>
</head>
<body onload="javascript:openKMCISWindow();">
<!-- ���νǸ�Ȯ�μ��� ��û form --------------------------->
<form name="reqKMCISForm" method="post" action = "">
    <input type="hidden" name="tr_cert"     value = "<%=tr_cert%>">
    <input type="hidden" name="tr_url"      value = "<%=tr_url%>">    
</form>

</body>
</html>
