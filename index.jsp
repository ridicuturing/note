<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.BufferedReader"%>  
<%@page import="java.io.FileReader"%>  
<%@page import="java.io.File"%> 
<%@page import="java.io.FileInputStream"%> 
<%@page import="java.io.FileWriter"%> 
<%@page import="java.util.*"%>


<html>

	<head>
		<title>writeout</title>

	</head>


	<body onload="document.getElementById('writeout').focus()">
		<% 
	String path = request.getSession().getServletContext().getRealPath("/") + "/data.txt";
	String name = request.getServletPath().split("/")[1];
	String write = null;
	String del = "del:";
	String clear = "..";

	write = request.getParameter("write");
	//如果带write参数
	out.println();
	if(write != "" && write != null){
		File file = new File(path);
		if(write.indexOf(clear) == 0){
			try{
				FileWriter w = new FileWriter(file);
				w.close();
				out.print(file.delete());
			} catch (Exception e) {  
	        }
		}else if(write.indexOf(del) != 0){
			try {   
				FileWriter w = new FileWriter(file,true);
				write = write.replaceAll("12138","121308");
				w.write(write.replace("<","&lt;") + "12138");
				w.close();
			} catch (Exception e) { 
				out.println(e.getMessage());
	        }
	    }else{ 
	    	if(file.exists()){
	    		Long l = file.length();
				byte[] filecontent = new byte[l.intValue()];
				
				try {  
	            FileInputStream in = new FileInputStream(file);  
		            in.read(filecontent);  
		            in.close();  
		        } catch (Exception e) {  
		            e.printStackTrace();  
		        }
		        String tt = new String(filecontent, "UTF-8");
				String[] t = tt.split("12138");
				//第一种删除方法 范围删除（如：1-10）
				if(write.indexOf("-") != -1){
					try{
						String num[] = write.split(del)[1].split("-");
						int count = 0;
						List<String> listtmp = Arrays.asList(t);
						List<String> list = new ArrayList<String>(listtmp);
						count = Integer.parseInt(num[1]) - Integer.parseInt(num[0]);
						if(count < 0)
							count = -count;
						count += 1;
						for(;count > 0;count--)
							list.remove(Integer.parseInt(num[0])-1);
						FileWriter w = new FileWriter(file);
						int length = list.size();
						for(int itmp = length;itmp > 0;itmp--){
							w.write(list.get(length-itmp) + "12138");
						}
						w.close();
					} catch (Exception e) {  
		        	}
	    		}else{
		    		//第二种删除方法 直接用用空格隔开的数字（如： 1 4 5）
					try{
						String num[] = write.split(del)[1].split(" ");
						//删除操作
						for(int i = 0 ; i < num.length ; i++){
							t[Integer.parseInt(num[i])-1] = "";
						}
						FileWriter w = new FileWriter(file);
						for(int i = 0 ; i < t.length ; i++){
							try{
								if(t[i] != ""){
									w.write(t[i] + "12138");
								}
								else{
								}
							} catch (Exception e) {  
		        			}
						}
						w.close();
					} catch (Exception e) {  
		        	}
		    	}
	    	}
		}
		response.sendRedirect(new String(request.getRequestURL()));
        return;
	}else if(write == ""){
		response.sendRedirect(new String(request.getRequestURL()));
        return;
	}
%>

		<script type="text/javascript">
	   	function del(num){
	   		num = num - 1;
	   		window.location.href='<%=(new String(request.getRequestURL()) + "?write=del:")%>' + num;
	   	}
	 	</script>


		<%
	   		File fileread = new File(path);
			if(fileread.exists()){
				Long l = fileread.length();
				byte[] filecontent = new byte[l.intValue()];
				
				try {  
		            FileInputStream in = new FileInputStream(fileread);  
		            in.read(filecontent);  
		            in.close();  
		        } catch (Exception e) {  
		            e.printStackTrace();  
		        }
				String tt = new String(filecontent, "UTF-8");
				String[] t = tt.replace("\n","<br>").split("12138");
				int num = 1;
				for(String s:t){
					if(!s.equals("")){
						s = s.replaceAll("121308", "12138");
						out.println(num++ + " " + "<button onclick=\"del(" + num + ")\"> del</button>  " + s + "<br>");
					}
				}
			}
	   %>
	   
		<form name=myform action= "<%=name%>">
			<textarea id="writeout" name="write" type="text"></textarea><br><br>
			<button type="submit" > write </button><br><br>
		</form>
	</body>
</html>