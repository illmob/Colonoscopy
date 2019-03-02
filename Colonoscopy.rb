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
# [vars] ######################################################################
ct  = "\x09\x09\x5b\x43\x6f\x64\x65\x4e"
ct += "\x61\x6d\x65\x5d\x3a\x09\x43\x6f"
ct += "\x6c\x6f\x6e\x6f\x73\x63\x6f\x70\x79"
pt  = "\x09\x09\x5b\x50\x72\x6f\x64\x75"
pt += "\x63\x65\x64\x5d\x3a\x09\x69\x6c"
pt += "\x6c\x4d\x6f\x62\x20\x2d\x20\x51"
pt += "\x31\x2f\x32\x30\x31\x39"
gt  = "\x09\x09\x5b\x4d\x6f\x74\x6f\x2f"
gt += "\x50\x53\x41\x5d\x3a\x09\x47\x65"
gt += "\x74\x20\x79\x6f\x20\x73\x68\x69"
gt += "\x74\x20\x63\x68\x65\x63\x6b\x65\x64\x21"
aa  = "\x3a\x3b\x3a\x6f\x2c\x3b\x63\x3b"
aa += "\x3a\x3b\x6c\x3a\x27\x78\x4d\x4d"
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
banner.append('[INITIALIZER]::')
banner.append('')
$diag = true
# [initial] ###################################################################
def initial
	$compdata = ""
	$md5 = Digest::MD5.new
	$counter = 0
	$wsize = 20000
	filesin	= []
	directory_name = "evidence"
	Dir.mkdir(directory_name) unless Dir.exists?(directory_name)
	filesin = ingestion
	filesin.each { | finfile |
		pp "EACH FILE IN: #{finfile}" if $diag
		if finfile.split(".")[-1] == "txt"
			begin
				project = finfile.to_s.split(".")[0]
			rescue
				begin
					project = finfile.split("\\")[-1]
				rescue
					project = finfile.split("/")[-1]
				end
			end
			$data = {:badstart => [], :quoted => [], :semi => [], :colon => [], :pipe => [], :nosplit => [], :email => [], :unknown => [], :tabbed => [], :cleaned => [], :upwd => []}
			pp "[PROJECTNAME]:: #{project}" if $diag
			$base = File.join(directory_name, project)
			pp "[BASEDIR]:: #{$base}" if $diag
			Dir.mkdir($base) unless Dir.exists?($base)
			pp "[MAKEDIR]:: PASSED" if $diag
			IO.foreach(finfile) {|x|
				$counter +=1
				#pp "[COUNTER]:: #{$counter}" if $diag
				x=x.strip()
				if checkfirst(x) == true; next; end
				#pp "[FAILED]:: checkfirst module" if $diag				
				if upwdsplit(x) == true; next; end
				#pp "[FAILED]:: userpassword module" if $diag
				pp "[EOF UNKNOWN]:: #{x}" if $diag
				if unknown(x) == true; next; end
				pp "[FAILED]:: unknown module" if $diag
			}
		end
		if finfile.split(".")[-1] == "gz"
			begin
				project = finfile.to_s.split(".")[0]
			rescue
				begin
					project = finfile.split("\\")[-1]
				rescue
					project = finfile.split("/")[-1]
				end
			end
			pp "[PROJECTNAME]:: #{project}" if $diag
			$base = File.join(directory_name, project)
			pp "[BASEDIR]:: #{$base}" if $diag
			Dir.mkdir($base) unless Dir.exists?($base)
			pp "[MAKEDIR]:: PASSED" if $diag
			Tar::Reader.new( Zlib::GzipReader.open(finfile)).each { |fzile|
				if fzile.header.size.to_i == 0; next; end
				$data = {:badstart => [], :quoted => [], :semi => [], :colon => [], :pipe => [], :nosplit => [], :email => [], :unknown => [], :tabbed => [], :cleaned => [], :upwd => []}
				compfile = fzile.header.name
				pp "[COMPFILE]:: #{compfile}" if $diag
				compfilelen = fzile.header.size
				pp "[LOADING]:: Reading GZ contents to memory, please wait" if $diag
				aaa = fzile.readlines
				puts "[PROCESSING]:: Processing #{fzile.header.name} contents"
				aaa.each { |x|
					$counter +=1
					x=x.strip()
					if checkfirst(x) == true; next; end
					#pp "[FAILED]:: checkfirst module" if $diag
					if upwdsplit(x) == true; next; end
					#pp "[FAILED]:: userpassword module" if $diag
					pp "[EOF UNKNOWN]:: #{x}" if $diag
					if unknown(x) == true; next; end
					pp "[FAILED]:: unknown module" if $diag
				}
			}
		end
		bufferflush
	}
end
# [ingestion] #################################################################
def ingestion
	filesin = []
	begin
		if File.directory? ARGV[0]
			Dir.entries(ARGV[0]).each {|fin| if fin.split(".")[-1].to_s == "gz"; filesin.append(fin.to_s); end }
			pp "[CONSUME]:: Directory of GZ files:" if $diag
			filesin.each{ | consume |
				pp "[GZFILES]:: #{consume}" if $diag
			}
		end
		if File.file? ARGV[0]
			filesin.append(ARGV[0])
			pp "Single file Filein: #{filesin}" if $diag
			filesin.each{ | consume |
				pp "[TXTFILE]:: #{consume}" if $diag
			}
		end
		return filesin
	rescue
		puts "Please enter a file.txt or directory containing .gz files\n[END]::"; exit
	end
end
# [makehash] ##################################################################
def makehash(datain)
	newhash = $md5.update(datain).hexdigest
	$md5.reset
	return newhash
end
# [validemail] ################################################################
def validemail(email)
	/.+@.+\..+/i.match(email)
end
# [checkfirst] ################################################################
def checkfirst(x)
	if ["!", '"', "#", "$", "%","&", "'", "(", ")", "*","+", ",", "-", ".", "/",":", ";", "<", "=", ">","?","\,", "\\"].include? x[0].to_s[0]
		if not validemail(if x.split(":").length >= 2;x.split(":")[0];end) || validemail(if x.split(";").length >= 2; x.split(";")[0] ; end)  || validemail(if x.split("|").length >= 2; x.split("|")[0] ;end) || validemail(if x.split("\t").length >= 2; x.split("\t")[0];end)
			if x[0].to_s[0] == '"'
				if $data[:quoted].length >= $wsize
					$data[:quoted].append(x)
					puts "[QUOTEWRITER]:: #{$counter}"
					IO.write(File.join($base,"quoted.txt"), $data[:quoted].join("\n"), mode: 'a')
					$data[:quoted] = []
					return true
				else
					$data[:quoted].append(x)
				end
			else
				if $data[:badstart].length >= $wsize
					$data[:badstart].append(x)
					puts "[BADCHARWRITER2]:: #{$counter}"
					IO.write(File.join($base,"badstart.txt"),$data[:badstart].join("\n"), mode: 'a')
					$data[:badstart] = []
				else
					$data[:badstart].append(x)
				end
			end
		else
			t = 0
			while t == 0
				begin
					pp "[LENRUN]:: Started Processing entry for catagorization" if $diag
					if x.split(":").length >= 2; if lenrun(":",x) == true; t = 1; return true; end; end
					if x.split(";").length >= 2; if lenrun(";",x) == true; t = 1; return true; end;	end
					if x.split("|").length >= 2; if lenrun("|",x) == true; t = 1; return true; end;	end
					if x.split("\t").length >= 2; if lenrun("\t",x) == true; t = 1; return true; end; end
					pp "[LENRUN]:: Finished Processing entry for catagorization" if $diag
				rescue
					t = 1
				end
				t = 1
			end
		end
	end
end
# [lenrun] ####################################################################
def lenrun(char, x)
	if x.split(char).length == 2
		set1	=	x.split(char)[0]
		set2	=	x.split(char)[1]
	end
	if x.split(char).length >= 3
		set1	=	x.split(char)[0]
		set2	=	x.split(char)[1]
		set3	=	x.split(char)[2]
	end
	if validemail(set1) == true; newx = set1+":"+set2; end
	if validemail(set2) == true; newx = set2+":"+set1; end
	if set3.to_s != ""
		if validemail(set3) == true
			if x.split(char).length >= 4
				newx = set3+":"+set1+"\t"+set2+x.split(char)[3..-1].join("\t")
			end
			if x.split(char).length == 3; newx = set3+":"+set1+"\t"+set2; end
		else
			$data[:unknown].append(x)
			return true
		end
	end
	if newx.to_s != ""
		$data[:cleaned].append(newx)
		if char.to_s "\t"
			pp "[TAB2]:: #{$counter}" if $diag
			if tabsplit(x) == true; return true; end
		end
		if char.to_s = ":"
			pp "[COLON2]:: #{$counter}" if $diag
			if colonsplit(x) == true; return true; end
		end
		if char.to_s = ";"
			pp "[SEMIC2]:: #{$counter}" if $diag
			if semisplit(x) == true; return true; end
		end
		if char.to_s = "|"
			pp "[PIPE2]:: #{$counter}" if $diag
			if pipesplit(x) == true; return true; end
		end
		pp "[USPWD]:: #{$counter}" if $diag
		if upwdsplit(x) == true; return true; end
	end
	pp "[UNKNOWN]:: #{$counter}" if $diag
	if unknown(x) == true; return true; end
	return true
end
# [tabsplit] ##################################################################
def tabsplit(x)
	if $data[:tabbed].length >= $wsize
		$data[:tabbed].append(x)
		puts "[TAB  WRITER]:: #{$counter}"
		IO.write(File.join($base,"tabbed.txt"), $data[:tabbed].join("\n"), mode: 'a')
		$data[:tabbed] = []
	else
		$data[:tabbed].append(x)
	end
	return true
end
# [pipesplit] #################################################################
def pipesplit(x)
	if $data[:pipe].length >= $wsize
		$data[:pipe].append(x)
		puts "[PIPE|WRITER]:: #{$counter}"
		IO.write(File.join($base,"pipe.txt"), $data[:pipe].join("\n"), mode: 'a')
		$data[:pipe] = []
	else
		$data[:pipe].append(x)
	end
	return true
end
# [semisplit] #################################################################
def semisplit(x)
	if $data[:semi].length >= $wsize
		$data[:semi].append(x)
		puts "[SEMI;WRITER]:: #{$counter}"
		IO.write(File.join($base,"semi.txt"), $data[:semi].join("\n"), mode: 'a')
		$data[:semi] = []
	else
		$data[:semi].append(x)
	end
	return true
end
# [colonsplit] ################################################################
def colonsplit(x)
	if $data[:colon].length >= $wsize
		$data[:colon].append(x)
		puts "[COLO:WRITER]:: #{$counter}"
		IO.write(File.join($base,"colon.txt"), $data[:colon].join("\n"), mode: 'a')
		$data[:colon] = []
	else
		$data[:colon].append(x)
	end
	return true
end
# [unknown] ###################################################################
def unknown(x)	
	if $data[:unknown].length >= $wsize
		puts "[KNOW?WRITER]:: #{$counter}"
		$data[:unknown].append(x)
		pp $data[:unknown].length if $diag
		IO.write(File.join($base,"unknown.txt"), $data[:unknown].join("\n"), mode: 'a')
		$data[:unknown] = []
	else
		$data[:unknown].append(x)
	end
	return true
end
# [upwdsplit] #################################################################
def upwdsplit(x)
	if $data[:upwd].length >= $wsize
		$data[:upwd].append(x)
		puts "[UPWDWRITER]:: #{$counter}"
		IO.write(File.join($base,"userpass.txt"), $data[:upwd].join("\n"), mode: 'a')
		$data[:upwd] = []
	else
		$data[:upwd].append(x)
	end
	return true
end
# [bufferflush] ###############################################################
def bufferflush
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
	puts "[DUMP]:: Creating unqiued Cleaned list"
	udump = $data[:cleaned].uniq
	puts "[DUMP]:: Creating sorted Cleaned list"
	sdump = udump.sort
	puts "[DUMP]:: Exporting Cleaned list"
	IO.write(File.join($base,"unique_sorted_cleaned.txt"), sdump.join("\n"), mode: 'a')
	puts "[EXIT]:: Application Finished"
end
################################# [MAIN LOGIC] ################################
puts banner.join("\n")
initial
