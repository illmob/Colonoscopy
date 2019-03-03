# [DEVELOPER] #################################################################
#
# illnmob, cause you didn't even try to make it
#
# [requirements] ##############################################################
#
#	Application does require the following gems
#		tar::	gem inststall tar
#		zlib::	gem install zlib
###############################################################################
require 'zlib'
require 'tar/reader'
require 'digest'
require 'ipaddr'
require 'iconv' unless String.method_defined?(:encode)
# [vars] ######################################################################
ct  = "\x09\x09\x5b\x43\x6f\x64\x65\x4e\x61\x6d\x65\x5d\x3a\x09\x43\x6f"
ct += "\x6c\x6f\x6e\x6f\x73\x63\x6f\x70\x79"
pt  = "\x09\x09\x5b\x50\x72\x6f\x64\x75\x63\x65\x64\x5d\x3a\x09\x69\x6c"
pt += "\x6c\x4d\x6f\x62\x20\x2d\x20\x51\x31\x2f\x32\x30\x31\x39"
gt  = "\x09\x09\x5b\x4d\x6f\x74\x6f\x2f"
gt += "\x50\x53\x41\x5d\x3a\x09\x47\x65\x74\x20\x79\x6f\x20\x73\x68\x69"
gt += "\x74\x20\x63\x68\x65\x63\x6b\x65\x64\x21"
aa  = "\x3a\x3b\x3a\x6f\x2c\x3b\x63\x3b\x3a\x3b\x6c\x3a\x27\x78\x4d\x4d"
aa += "\x3a\x64\x6f\x6c\x63\x63\x63\x6c\x78\x6b\x3a"
ab  = "\x2e\x6c\x4b\x4e\x4b\x30\x30\x58\x57\x4d\x4d\x4d\x30\x6c\x2e"
ac  = "\x63\x58\x4d\x4d\x57\x4b\x4f\x4f\x30\x4e\x4d\x4d\x4d\x6b\x2e"
ad  = "\x2e\x3b\x6c\x64\x78\x78\x78\x6f"
ad += "\x6b\x57\x4d\x57\x4f\x6f\x3a\x3b\x3a\x6c\x6b\x4e\x4d\x57\x64\x2e"
ae  = "\x3b\x64\x30\x4e\x4d\x4d\x4d\x57\x58\x6b\x3a"
af  = "\x2e\x2e\x2c\x2e\x2e\x2e\x2e\x2e\x2e\x2e\x3a\x4d\x4d\x6f"
ag  = "\x3a\x4d\x4d\x30\x2e\x2c\x3a\x63\x63\x63\x6f\x78\x78\x6f\x6f\x3a\x2e"
ah  = "\x2e\x63\x30\x4d\x4d\x4d\x4d\x4d\x4d\x4d\x57\x4b\x6b\x6c\x27"
ai  = "\x2e\x63\x30\x4d\x4d\x4d\x4d\x4d\x4d\x4d\x57\x4b\x6b\x6c\x27"
ai  = "\x6f\x57\x4d\x57\x6f"
aj  = "\x2e\x6b\x4d\x4d\x4b\x3b"
ak  = "\x2e\x6c\x4b\x4d\x4d\x4e\x78\x78\x78\x78\x64\x6f\x3a\x27"
# [banner] ####################################################################
banner = []
banner.append('-'*80)
banner.append("\x20"*5+"lXMMXk:."+"\x20"*51+",Kx,")
banner.append("\x20"*7+".ckNMMNx:."+"\x20"*47+":0MMK;")
banner.append("\x20"*11+"'lOWMMKd,"+"\x20"*46+"'0MMx")
banner.append("\x20"*15+",oKMMM0l'"+"\x20"*36+".'."+"\x20"*5+"xMMd")
banner.append("\x20"*18+".;dKMMWOl'"+"\x20"*21+af+"\x20"*6+"0MM'")
banner.append("\x20"*23+".;xXMMWOc."+"\x20"*14+aa)
banner.append("\x20"*25+",xWMM0c."+"\x20"*14+",:'.'.'.."+"\x20"*3+ag)
banner.append("\x20"*22+"'dNMMKl."+"\x20"*28+"lWMX."+"\x20"*7+"odooddd:")
banner.append("\x20"*18+"'dNMMKl."+"\x20"*28+".cKMMk"+"\x20"*8+"kMMc"+"\x20"*1+".odok:")
banner.append("\x20"*15+",dXMM0l."+"\x20"*21+".:c;;;:lxKMMNd."+"\x20"*7+";XMWl"+"\x20"*5+"ldlk.")
banner.append("\x20"*12+",xNMM0c."+"\x20"*21+ah+"\x20"*6+".;dNMMk."+"\x20"*7+".klk;")
banner.append("\x20"*9+"'dNMMKl."+"\x20"*21+".c0MMWx,"+"\x20"*1+"..."+"\x20"*3+ak+"\x20"*12+"klO,")
banner.append("\x20"*7+",KMMKl."+"\x20"*22+":OMMWk;"+"\x20"*7+ak+"\x20"*16+"O:0.")
banner.append("\x20"*7+"dMM0'"+"\x20"*21+".cOWMNx;"+"\x20"*6+".'dKMMXd'"+"\x20"*25+".0ck")
banner.append("\x20"*5+";MMO"+"\x20"*20+".c0MMNx,"+"\x20"*7+"'dNMMXo."+"\x20"*30+"llO'")
banner.append("\x20"*6+"dMM,"+"\x20"*17+".cOMMWk,"+"\x20"*7+"'oXMMXo."+"\x20"*32+".Kcd")
banner.append("\x20"*6+"lMMl"+"\x20"*17+"dWMMK."+"\x20"*6+".oXMMXo."+"\x20"*36+"k:K")
banner.append("\x20"*6+".XMW;"+"\x20"*17+".xWMWo"+"\x20"*3+"lXMMXo'"+"\x20"*39+":ok'")
banner.append("\x20"*7+".kMM0;"+"\x20"*17+".dWMWd"+"\x20"*2+"dWMNl"+"\x20"*40+".0cl")
banner.append("\x20"*9+aj+"\x20"*18+"oWMWx."+"\x20"*1+ai+"\x20"*38+"0:0")
banner.append("\x20"*10+".kMMK;"+"\x20"*18+"oWMWx."+"\x20"*1+ai+"\x20"*37+"oc0.")
banner.append("\x20"*12+".kMMK;"+"\x20"*18+"oWMWx."+"\x20"*1+ai+"\x20"*35+".0cd")
banner.append("\x20"*14+".xWMX:"+"\x20"*18+"lNMWx."+"\x20"*1+"lNMWd."+"\x20"*33+"dlO'")
banner.append("\x20"*16+".xWMNc"+"\x20"*18+"cNMMk."+"\x20"*1+"cNMMk."+"\x20"*32+"Ock;")
banner.append("\x20"*18+".xWMNc"+"\x20"*18+"cNMMk."+"\x20"*1+":KMMk."+"\x20"*31+"odddc,..")
banner.append("\x20"*20+".xWMNc"+"\x20"*18+"cNMMk'"+"\x20"*1+";KMMk."+"\x20"*30+".lldxxx.")
banner.append("\x20"*22+".xWMNc"+"\x20"*18+"cNMM0,"+"\x20"*1+";KMMk."+"\x20"*32+"..'")
banner.append("\x20"*24+".dWMNl"+"\x20"*18+":KMM0;"+"\x20"*1+";0MMO'")
banner.append("\x20"*27+ai+"\x20"*18+",0MMK,"+"\x20"*1+",0MM0,")
banner.append("\x20"*29+ai+"\x20"*18+",0MMx"+"\x20"*1+",0MM0,")
banner.append("\x20"*31+ai+"\x20"*18+"xMMo"+"\x20"*3+",0MM0.")
banner.append("\x20"*33+"lNMWd."+"\x20"*16+"WMK"+"\x20"*5+",XMW'")
banner.append("\x20"*35+"cNMWx."+"\x20"*13+".WMK"+"\x20"*6+"'MM0"+ct)
banner.append("\x20"*37+"cNMWx."+"\x20"*10+".0MM:"+"\x20"*7+"XMX"+pt)
banner.append("\x20"*39+"cNMWx'"+"\x20"*6+".oNMW:"+"\x20"*7+";MMk"+gt)
banner.append("\x20"*42+ac+"\x20"*7+"lWMX.")
banner.append("\x20"*44+ad)
banner.append("\x20"*53+ae)
banner.append('-'*80)
banner.append('[INITIALIZER]:: Application initialized')
banner.append('')
# [initial] ###################################################################
def initial
	pp "[INITAL]:: Entering" if $diag
	$diag = false
	if ARGV[1].to_s != ""; $diag = true; end
	$inilist =	{:badstart => [],:quoted => [],:semi => [],:colon => [], 
				:pipe => [],:nosplit => [],:email => [],:unknown => [], 
				:tabbed => [],:cleaned => [],:upwd => [],:badconvert => []
				}
	$speclist = ["!", '"', "#", "$","%", "&", "'", "(",
				")", "*", "+", ",","-", ".", "/", ":",
				";", "<", "=", ">","?", "\,", "\\"
				]
	$compdata = ""
	$md5 = Digest::MD5.new
	$counter = 0
	$wsize = 20000
	filesin	= []
	$directory_name = "evidence"
	Dir.mkdir($directory_name) unless Dir.exists?($directory_name)
	pp "[INITAL]:: Exiting" if $diag
end
# [mainfun] ###################################################################
def mainfun
	pp "[MAINFUN]:: Entering" if $diag
	filesin = ingestion
	filesin.each { | finfile |
		procfiles(finfile)
		pp "[MAINFUN]:: Inspecting file: #{finfile}" if $diag
		if finfile.split(".")[-1] == "txt"
			pp "[MAINFUN]:: Input file is TXT" if $diag
			inoutput(finfile)
		end
		if finfile.split(".")[-1] == "gz"
			pp "[MAINFUN]:: Input file is GZ" if $diag
			tarpit(finfile)
		end
		bufferflush
	}
	pp "[MAINFUN]:: Exiting" if $diag
end
# [ingestion] #################################################################
def ingestion
	pp "[CONSUME]:: Entering" if $diag
	filesin = []
	begin
		if File.directory? ARGV[0]
			Dir.entries(ARGV[0]).each { | fin | if fin.split(".")[-1].to_s == "gz"; filesin.append(fin.to_s); end }
			pp "[CONSUME]:: Directory of GZ files:" if $diag
			filesin.each { | consume | pp "[GZFILES]:: #{consume}" if $diag }
		end
		if File.file? ARGV[0]
			filesin.append(ARGV[0])
			pp "[CONSUME]:: Single file Filein:" if $diag
			filesin.each { | consume | pp "[TXTFILE]:: #{consume}" if $diag }
		end
		return filesin
	rescue
		puts "[CONSUME]:: Please enter a file.txt or directory containing .gz files\n[END]::"; exit
	end
	pp "[CONSUME]:: Exiting" if $diag
end
# [projname] ##################################################################
def projname(project)
	pp "[PROJECT]:: Entering" if $diag
	begin
		projectname = project.split(".")[0]
		begin
			projectname = project.split("\\")[-1]
			pp "[PROJECT]:: WIN Project name set" if $diag
		rescue
			projectname = project.split("/")[-1]
			pp "[PROJECT]:: LIN Project name set" if $diag
		end
	rescue
		pp "[PROJECT]:: Could not assign Project name, using RANDOM name"
		projectname = "RANDOM"
	end
	pp "[PROJECT]:: Exiting" if $diag
	return projectname
end
# [procfiles] ##################################################################
def procfiles(infile)
	pp "[PROCFILE]:: Entering" if $diag
	project = projname(infile)
	pp "[PROCFILE]:: Project: #{project}" if $diag
	$base = File.join($directory_name, project)
	pp "[PROCFILE]:: Base location: #{$base}" if $diag
	Dir.mkdir($base) unless Dir.exists?($base)
	pp "[PROCFILE]:: File/Folder creation: PASSED" if $diag
	pp "[PROCFILE]:: Exiting" if $diag
end
# [inoutput] ##################################################################
def inoutput(infile)
	pp "[IOREADER]:: Entering" if $diag
	$data = $inilist
	IO.foreach(infile) { | x | if gauntlet(x) == true; next; end }
	pp "[IOREADER]:: Exiting" if $diag
end
# [tarpit] ##################################################################
def tarpit(infile)
	pp "[TARPIT]:: Entering" if $diag
	Tar::Reader.new( Zlib::GzipReader.open(infile)).each { |fzile|
		$data = $inilist
		if fzile.header.size.to_i == 0; next; end
		compfile = fzile.header.name
		pp "[TARPIT]:: Compressed file: #{compfile}" if $diag
		compfilelen = fzile.header.size
		pp "[TARPIT]:: Reading GZ contents to memory, please wait" if $diag
		fzile.readlines.each { | x | if gauntlet(x) == true; next; end }
	}
	pp "[TARPIT]:: Exiting" if $diag
end
# [gauntlet] ##################################################################
def gauntlet(xstring)
	pp "[GUANTLET]:: Entering" if $diag
	$counter +=1
	estring = encoded(xstring)
	if checkfirst(estring) == true; pp "[GUANTLET]:: Encoded: #{estring}" if $diag; return true; 
		else; pp "[ERROR]:: Guantlet failed checkfirst: #{xstring}" if $diag; end 
	if upwdsplit(estring) == true; pp "[GUANTLET]:: Encoded: #{estring}" if $diag; return true;	
		else; pp "[ERROR]:: Guantlet failed upwdsplit: #{xstring}" if $diag; end
	if unknown(estring) == true; pp "[GUANTLET]:: Encoded: #{estring}" if $diag; return true; 
		else; pp "[ERROR]:: Guantlet failed unknown: #{xstring}" if $diag; end
		pp "[GUANTLET]:: Exiting" if $diag
	return true
end
# [encoded] ##################################################################
def encoded(plainstring)
	pp "[ENCODEX]:: Entering" if $diag
	begin
		encodedstring = plainstring.strip("\r\n")
		pp "[ENCODEX]:: Generic \r\n Strip newline from #{encodedstring}" if $diag
	rescue
		begin
			encodedstring = plainstring.strip("\n")
			pp "[ENCODEX]:: Generic newline Strip newline from #{encodedstring}" if $diag
		rescue
			begin
				encodedstring = plainstring.strip()
				pp "[ENCODEX]:: Generic Strip from #{encodedstring}" if $diag
			rescue
				begin
					encodedstring = convert8string(plainstring).strip()
					pp "[ENCODEX]:: Encode string in utf8 #{encodedstring}" if $diag
				rescue
					begin
						encodedstring =  conver16string(plainstring).strip()
						pp "[ENCODEX]:: Encode string in utf16 #{encodedstring}" if $diag
					rescue
						begin
							encodedstring = utf821628(plainstring).strip()
							pp "[ENCODEX]:: Encode string UTC8=>16=>8 #{encodedstring}" if $diag
						rescue
							pp "[ENCODEX]:: Failed in conversion #{encodedstring}" if $diag
						end
						return encodedstring
					end
					return encodedstring
				end
				return encodedstring				
			end
			return encodedstring
		end
		return encodedstring
	end
	pp "[ENCODEX]:: Exiting" if $diag
	return encodedstring
end
# [makehash] ##################################################################
def makehash(datain)
	pp "[makehash]:: Entering" if $diag
	newhash = $md5.update(datain).hexdigest
	$md5.reset
	return newhash
	pp "[makehash]:: Exiting" if $diag
end
# [validemail] ################################################################
def validemail(email)
	pp "[validemail]:: Entering" if $diag
	if /.+@.+\..+/i.match(email); return true; end
	pp "[validemail]:: Exiting" if $diag
end
# [valid4ip] ################################################################
def valid4ip(address)
	pp "[valid4ip]:: Entering" if $diag
	ip = IPAddr.new(address)
	if ip.ipv4?; return true; end
	pp "[valid4ip]:: Exiting" if $diag
end
# [valid6ip] ################################################################
def valid6ip(address)
	pp "[valid6ip]:: Entering" if $diag
	ip = IPAddr.new(address)
	if ip.ipv6?; return true; end
	pp "[valid6ip]:: Exiting" if $diag
end
# [convert8string] ################################################################
def convert8string(str1)
	pp "[convert8string]:: Entering" if $diag
	if String.method_defined?(:encode)
		return str1.encode!('UTF-8', :invalid => :replace, :replace => '')
	else
		ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
		return ic.iconv(str1)
	end
	pp "[convert8string]:: Exiting" if $diag
end
# [convert16string] ################################################################
def convert16string(str1)
	pp "[convert16string]:: Entering" if $diag
	if String.method_defined?(:encode)
		str2 = str1.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
		return str2
	else
		ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
		return ic.iconv(str1)
	end
	pp "[convert16string]:: Exiting" if $diag
end
# [utf821628] ################################################################
def utf821628(str1)
	pp "[UTF2821628]:: Entering" if $diag
	if String.method_defined?(:encode)
		str2 = str1.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
		str3 = str1.encode!('UTF-8', 'UTF-16')
		return str3
	else
		ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
		return ic.iconv(str1)
	end
	pp "[UTF2821628]:: Exiting" if $diag
end
# [checkfirst] ################################################################
def checkfirst(x)
	pp "[VALIDATOR]:: Entering" if $diag
	if $speclist.include? x[0].to_s[0]
		pp "[VALIDATOR]:: Found lead character in speclist" if $diag
		if not validemail(if x.split(":").length >= 2;x.split(":")[0];end)
			if not validemail(if x.split(";").length >= 2; x.split(";")[0];end)
				if not validemail(if x.split("|").length >= 2; x.split("|")[0];end)
					if not validemail(if x.split("\t").length >= 2; x.split("\t")[0];end)
						pp "[VALIDATOR]:: No valid email in the first set" if $diag
						if x[0].to_s[0] == '"'
							pp "[VALIDATOR]:: Append to Quoted list" if $diag
							quotesplit(x)
						end
						if x[0].to_s[0] == '?'
							x = x.strip()
							begin
								begin
									if validemail(x.split(":")[1]); x = x.split(":")[1].strip(" ")+":"+x.split(":")[2..-1].join(":"); lenrun(":",x); end
								rescue
									begin
										if validemail(x.split(";")[1]); x = x.split(";")[1].strip(" ")+";"+x.split(";")[2..-1].join(";"); lenrun(";",x); end
									rescue
										begin
											if validemail(x.split("|")[1]); x = x.split("|")[1].strip(" ")+"|"+x.split("|")[2..-1].join("|"); lenrun("|",x); end
										rescue
											begin
												if validemail(x.split("\t")[1]); x = x.split("\t")[1].strip(" ")+"\t"+x.split("\t")[2..-1].join("\t"); lenrun("\t",x); end
											rescue
											end
										end
									end
								end
							rescue
								pp "[VALIDATOR]:: Append to badsplit list" if $diag
								badsplit(x)
							end
						end
					end
				end
			end
		end
	else
		pp "[VALIDATOR]:: Leading character passes first validation point" if $diag
		t = 0
		while t == 0
			begin
				pp "[LENRUN]:: Started Processing entry for catagorization" if $diag
				if x.split(":").length >= 2; if lenrun(":",x) == true; t = 1; pp "[VALIDATOR]:: split at ':'" if $diag; return true; end; end
				if x.split(";").length >= 2; if lenrun(";",x) == true; t = 1; pp "[VALIDATOR]:: split at ';'" if $diag; return true; end; end
				if x.split("|").length >= 2; if lenrun("|",x) == true; t = 1; pp "[VALIDATOR]:: split at '|'" if $diag; return true; end; end
				if x.split("\t").length >= 2; if lenrun("\t",x) == true; t = 1; pp "[VALIDATOR]:: split at '\t'" if $diag; return true; end; end
				pp "[LENRUN]:: Finished Processing entry for catagorization" if $diag
			rescue
				t = 1
			end
			t = 1
		end
	end
	pp "[VALIDATOR]:: Exiting" if $diag
end
# [lenrun] ####################################################################
def lenrun(char, x)
	pp "[LENRUN]:: Entering" if $diag
	if x.split(char).length == 2
		pp "[LENRUN]:: Length of x is 2" if $diag
		set1 = x.split(char)[0]; set2 = x.split(char)[1]
		if validemail(set1) == true; $newx = set1+char+set2; pp "[LENRUN]:: Valid set1 #{set1}" if $diag; end		
		if validemail(set2) == true; $newx = set2+char+set1; pp "[LENRUN]:: Valid set2 #{set2}" if $diag; end
		if validemail(set1) != true && if validemail(set2) != true; upwdsplit(x); pp "[USPWD]:: NO VALID EMAILS FOUND: #{x} #{$counter}" if $diag; return true; end; end
	end
	if x.split(char).length >= 3
		pp "[LENRUN]:: Length of x is 3 or >" if $diag
		set1 = x.split(char)[0]; set2 = x.split(char)[1]; set3 = x.split(char)[2]
		if x.split(char).length > 3; set4 = ":"+x.split(char)[3..-1].join(char); else; set4 = ""; end
		if validemail(set1) == true && if validemail(set2) != true || if validemail(set3) != true; $newx = set1+char+set2+char+set3+set4; pp "[LENRUN]:: Valid set1 #{set1}" if $diag; end; end; end
		if validemail(set2) == true && if validemail(set1) != true || if validemail(set3) != true; $newx = set2+char+set1+char+set3+set4; pp "[LENRUN]:: Valid set2 #{set2}" if $diag; end; end; end
		if validemail(set3) == true && if validemail(set1) != true || if validemail(set2) != true; $newx = set3+char+set1+char+set2+set4; pp "[LENRUN]:: Valid set3 #{set3}" if $diag; end; end; end
		if validemail(set1) != true && if validemail(set2) != true && if validemail(set3) != true || if validemail(set4) != true; unknown(x); pp "[USPWD]:: NO VALID EMAILS FOUND: #{x} #{$counter}" if $diag; return true; end; end; end; end
	end
	if $newx.to_s != ""
		pp "[LENRUN]:: new X is not null" if $diag
		$data[:cleaned].append($newx)
		pp "[LENRUN]:: Appended new X to cleaned list" if $diag
		if char.to_s == "\t"; if tabsplit($newx) == true; pp "[LENRUN]:: TAB2 - #{$newx} #{$counter}" if $diag; return true; end; end
		if char.to_s == ":"; if colonsplit($newx) == true; pp "[LENRUN]:: COLON - #{$newx} #{$counter}" if $diag; return true; end; end
		if char.to_s == ";"; if semisplit($newx) == true; pp "[LENRUN]:: SEMI - #{$newx} #{$counter}" if $diag; return true; end; end
		if char.to_s == "|"; if pipesplit($newx) == true; pp "[LENRUN]:: PIPE - #{$newx} #{$counter}" if $diag; return true; end; end
	else
		if unknown(x) == true; pp "[UNKNOWN]:: NO VALID FORMATS FOUND: #{$newx} #{$counter}" if $diag; return true; end
	end
	pp "[LENRUN]:: Exiting" if $diag
end
# [badsplit] ##################################################################
def badsplit(x)
	pp "[BADCHARWRITER]:: Entering" if $diag
	if $data[:badstart].length >= $wsize
		$data[:badstart].append(x)
		puts "[BADCHARWRITER]:: #{$counter}"
		IO.write(File.join($base,"badstart.txt"),$data[:badstart].join("\n"), mode: 'a')
		$data[:badstart] = []
	else
		puts "[BADCHAR]:: #{x}"
		$data[:badstart].append(x)
	end
	pp "[BADCHARWRITER]:: Exiting" if $diag
	return true
end
# [tabsplit] ##################################################################
def tabsplit(x)
	pp "[TAB\\tWRITER]:: Entering" if $diag
	if $data[:tabbed].length >= $wsize
		puts "[TAB\\tWRITER]:: #{$counter}"
		IO.write(File.join($base,"tabbed.txt"), $data[:tabbed].join("\n"), mode: 'a')
		$data[:tabbed] = []
		$data[:tabbed].append(x)
	else
		$data[:tabbed].append(x)
	end
	pp "[TAB\\tWRITER]:: Exiting" if $diag
	return true
end
# [quotesplit] #################################################################
def quotesplit(x)
	pp "[QUOTEWRITER]:: Entering" if $diag
	if $data[:quoted].length >= $wsize
		$data[:quoted].append(x)
		puts "[QUOTEWRITER]:: #{$counter}"
		IO.write(File.join($base,"quoted.txt"), $data[:quoted].join("\n"), mode: 'a')
		$data[:quoted] = []
	else
		puts "[QUOTEWRITER]:: #{x}"
		$data[:quoted].append(x)
	end
	pp "[QUOTEWRITER]:: Exiting" if $diag
	return true
end
# [pipesplit] #################################################################
def pipesplit(x)
	pp "[PIPE|WRITER]:: Entering" if $diag
	if $data[:pipe].length >= $wsize
		puts "[PIPE|WRITER]:: #{$counter}"
		IO.write(File.join($base,"pipe.txt"), $data[:pipe].join("\n"), mode: 'a')
		$data[:pipe] = []
		$data[:pipe].append(x)
	else
		$data[:pipe].append(x)
	end
	pp "[PIPE|WRITER]:: Exiting" if $diag
	return true
end
# [semisplit] #################################################################
def semisplit(x)
	pp "[SEMI;WRITER]:: Entering" if $diag
	if $data[:semi].length >= $wsize
		puts "[SEMI;WRITER]:: #{$counter}"
		IO.write(File.join($base,"semi.txt"), $data[:semi].join("\n"), mode: 'a')
		$data[:semi] = []
		$data[:semi].append(x)
	else
		$data[:semi].append(x)
	end
	pp "[SEMI;WRITER]:: Exiting" if $diag
	return true
end
# [colonsplit] ################################################################
def colonsplit(x)
	pp "[COLO:WRITER]:: Entering" if $diag
	if $data[:colon].length >= $wsize
		puts "[COLO:WRITER]:: #{$counter}"
		IO.write(File.join($base,"colon.txt"), $data[:colon].join("\n"), mode: 'a')
		$data[:colon] = []
		$data[:colon].append(x)
	else
		$data[:colon].append(x)
	end
	pp "[COLO:WRITER]:: Exiting" if $diag
	return true
end
# [unknown] ###################################################################
def unknown(x)	
	pp "[KNOW?WRITER]:: Entering" if $diag
	if $data[:unknown].length >= $wsize
		puts "[KNOW?WRITER]:: #{$counter}"
		IO.write(File.join($base,"unknown.txt"), $data[:unknown].join("\n"), mode: 'a')
		$data[:unknown] = []
		$data[:unknown].append(x)
	else
		$data[:unknown].append(x)
	end
	pp "[KNOW?WRITER]:: Exiting" if $diag
	return true
end
# [upwdsplit] #################################################################
def upwdsplit(x)
	pp "[UPWDWRITER]:: Entering" if $diag
	if $data[:upwd].length.to_i >= $wsize
		puts "[UPWDWRITER]:: #{$counter}"
		IO.write(File.join($base,"userpass.txt"), $data[:upwd].join("\n"), mode: 'a')
		$data[:upwd] = []
		$data[:upwd].append(x)
	else
		$data[:upwd].append(x)
	end
	pp "[UPWDWRITER]:: Exiting" if $diag
	return true
end
# [bufferflush] ###############################################################
def bufferflush
	pp "[FINAL]:: Entering" if $diag
	# final writer for anything left over at end of interations < 100000
	# ::[DATASTRUCT]:: $data = {:badstart => [], :quoted => [], :semi => [], :colon => [], :pipe => [], :nosplit => [], :email => [], :unknown => [], :tabbed => [], :cleaned => []}
	puts "[FINAL]:: Write buffer to disk"
	IO.write(File.join($base,"badstart.txt"), $data[:badstart].join("\n"), mode: 'a') if $data[:badstart].length > 0
	IO.write(File.join($base,"tabbed.txt"), $data[:tabbed].join("\n"), mode: 'a') if $data[:tabbed].length > 0
	IO.write(File.join($base,"quoted.txt"), $data[:quoted].join("\n"), mode: 'a') if $data[:quoted].length > 0
	IO.write(File.join($base,"semi.txt"), $data[:semi].join("\n"), mode: 'a') if $data[:semi].length > 0
	IO.write(File.join($base,"colon.txt"), $data[:colon].join("\n"), mode: 'a') if $data[:colon].length > 0
	IO.write(File.join($base,"pipe.txt"), $data[:pipe].join("\n"), mode: 'a') if $data[:pipe].length > 0
	IO.write(File.join($base,"email.txt"), $data[:email].join("\n"), mode: 'a') if $data[:email].length > 0
	IO.write(File.join($base,"unknown.txt"), $data[:unknown].join("\n"), mode: 'a') if $data[:unknown].length > 0
	puts "[FINAL]:: Creating unqiued Cleaned list"
	udump = $data[:cleaned].uniq
	puts "[FINAL]:: Creating sorted Cleaned list"
	sdump = udump.sort
	puts "[FINAL]:: Exporting Cleaned list"
	IO.write(File.join($base,"unique_sorted_cleaned.txt"), sdump.join("\n"), mode: 'a')
	pp "[FINAL]:: Exiting" if $diag
end
################################# [MAIN LOGIC] ################################
puts banner.join("\n")
initial
mainfun
pp "[INITIALIZER]:: Application terminated"
