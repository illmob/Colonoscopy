banner  = '-'*80+"\n"
banner += ' '*5+"lXMMXk:."+" "*51+",Kx,"
banner += ' '*7+".ckNMMNx:."+" "*47+":0MMK;"
banner += ' '*11+"'lOWMMKd,"+" "*46+"'0MMx"
banner += ' '*15+",oKMMM0l'"+" "*36+".'."+" "*5+"xMMd"
banner += ' '*18+".;dKMMWOl'"+" "*21+"..,.......:MMo"+" "*6+"0MM'"
banner += ' '*23+".;xXMMWOc."+" "*14+":;:o,;c;:;l:'xMM:dolccclxk:"
banner += ' '*25+",xWMM0c."+" "*14+",:'.'.'.."+" "*3+":MM0.,:cccoxxoo:."
banner += ' '*22+"'dNMMKl."+" "*28+"lWMX."+" "*7+"odooddd:"
banner += ' '*18+"'dNMMKl."+" "*28+".cKMMk"+" "*8+"kMMc"+" "*1+".odok:"
banner += ' '*15+",dXMM0l."+" "*21+".:c;;;:lxKMMNd."+" "*7+";XMWl"+" "*5+"ldlk."
banner += ' '*12+",xNMM0c."+" "*21+".c0MMMMMMMWKkl'"+" "*6+".;dNMMk."+" "*7+".klk;"
banner += ' '*9+"'dNMMKl."+" "*21+".c0MMWx,"+" "*1+"..."+" "*3+".lKNK00XWMMM0l."+" "*11+"klO,"
banner += ' '*7+",KMMKl."+" "*22+":OMMWk;"+" "*7+".lKMMNxxxxdo:'"+" "*16+"O:0."
banner += ' '*7+"dMM0'"+" "*21+".cOWMNx;"+" "*47+"'dKMMXd'"+" "*25+".0ck"
banner += ' '*5+";MMO"+" "*20+".c0MMNx,"+" "*7+"'dNMMXo."+" "*29+"llO'"
banner += ' '*6+"dMM,"+" "*17+".cOMMWk,"+" "*7+"'oXMMXo."+" "*32+".Kcd"
banner += ' '*6+"lMMl"+" "*17+"dWMMK."+" "*6+".oXMMXo."+" "*36+"k:K"
banner += ' '*6+".XMW;"+" "*17+".xWMWo"+" "*3+"lXMMXo'"+" "*39+":ok'"
banner += ' '*7+".kMM0;"+" "*17+".dWMWd"+" "*2+"dWMNl"+" "*40+".0cl"
banner += ' '*9+".kMMK;"+" "*18+"oWMWx."+" "*1+"oWMWo"+" "*39+"0:0"
banner += ' '*10+".kMMK;"+" "*18+"oWMWx."+" "*1+"oWMWo"+" "*37+"oc0."
banner += ' '*12+".kMMK;"+" "*18+"oWMWx."+" "*1+"oWMWo"+" "*35+".0cd"
banner += ' '*14+".xWMX:"+" "*18+"lNMWx."+" "*1+"lNMWd."+" "*33+"dlO'"
banner += ' '*16+".xWMNc"+" "*18+"cNMMk."+" "*1+"cNMMk."+" "*32+"Ock;"
banner += ' '*18+".xWMNc"+" "*18+"cNMMk."+" "*1+":KMMk."+" "*31+"odddc,.."
banner += ' '*20+".xWMNc"+" "*18+"cNMMk'"+" "*1+";KMMk."+" "*30+".lldxxx."
banner += ' '*22+".xWMNc"+" "*18+"cNMM0,"+" "*1+";KMMk."+" "*32+"..'"
banner += ' '*24+".dWMNl"+" "*18+":KMM0;"+" "*1+";0MMO'"
banner += ' '*27+"oWMWo"+" "*18+",0MMK,"+" "*1+",0MM0,"
banner += ' '*29+"oWMWo"+" "*18+",0MMx"+" "*1+",0MM0,"
banner += ' '*31+"oWMWo"+" "*18+"xMMo"+" "*3+",0MM0."
banner += ' '*33+"lNMWd."+" "*16+"WMK"+" "*5+",XMW'"
banner += ' '*35+"cNMWx."+" "*13+".WMK"+" "*6+"'MM0"+"\x09\x09\x5b\x43\x6f\x64\x65\x4e\x61\x6d\x65\x5d\x3a\x09\x43\x6f\x6c\x6f\x6e\x6f\x73\x63\x6f\x70\x79"
banner += ' '*37+"cNMWx."+" "*10+".0MM:"+" "*7+"XMX"+"\x5c\x74\x5c\x74\x5b\x50\x72\x6f\x64\x75\x63\x65\x64\x5d\x3a\x5c\x74\x69\x6c\x6c\x4d\x6f\x62\x20\x2d\x20\x51\x31\x2f\x32\x30\x31\x39"
banner += ' '*39+"cNMWx'"+" "*6+".oNMW:"+" "*7+";MMk"+"\x5c\x74\x5c\x74\x5b\x4d\x6f\x74\x6f\x2f\x50\x53\x41\x5d\x3a\x5c\x74\x47\x65\x74\x20\x79\x6f\x20\x73\x68\x69\x74\x20\x63\x68\x65\x63\x6b\x65\x64\x21"
banner += ' '*42+"cXMMWKOO0NMMMk."+" "*7+"lWMX."
banner += ' '*43+".;ldxxxokWMWOo:;:lkNMWd."
banner += ' '*53+";d0NMMMWXk:\n"
banner += '-'*80
banner += '[Initialize]"'
banner += ''

def initial

	$counter = 0
	$wsize = 500000
	$infile = ARGV[0]
	$diag = false
	begin
		if ARGV[1].to_s != ""
			$diag = true
		else
			$diag = false
		end
	rescue
		$diag = false
	end
	$data = {:badstart => [], :quoted => [], :semi => [], :colon => [], :pipe => [], :nosplit => [], :email => [], :unknown => [], :tabbed => [], :cleaned => []}
	directory_name = "evidence"
	Dir.mkdir(directory_name) unless Dir.exists?(directory_name)
	project = ARGV[0].to_s.split(".")[0]
	begin
		project = project.split("\\")[-1]
	rescue
		begin
			project = project.split("/")[-1]
		rescue
			project = "RANDOM"
		end
	end
	$base = File.join(directory_name, project)
	Dir.mkdir($base) unless Dir.exists?($base)
end
def validemail(email)
	/.+@.+\..+/i.match(email)
end
def checkfirst(x)
	if $data[:cleaned].length >= $wsize
		puts "[CLEANWRITER]:: #{$counter}"
		IO.write(File.join($base,"cleaned.txt"), $data[:cleaned].join("\n"), mode: 'a')
		$data[:cleaned] = []
	end
	if ["!", '"', "#", "$", "%","&", "'", "(", ")", "*",
		"+", ",", "-", ".", "/",":", ";", "<", "=", ">","?",
		"\,", "\\"].include? x[0].to_s[0]
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
				t = 0
				while t == 0
					if x.split(":").length == 3
						email = x.split(":")[1]
						if validemail(email) && x.split(":")[2..-1].join(":").to_s != ""
							pass = x.split(":")[2..-1].join(":") if x.split(":")[2].to_s != ""
							newx = email+":"+pass
							pp "[COLONCLEAN3]:: #{$counter}" if $diag
							$data[:cleaned].append(newx)
							if colonsplit(newx) == true
								t = 1
								return true
							else
								$data[:unkwnow].append(x)
							end
						end
					end
					if x.split(";").length == 3; 
						email = x.split(";")[1]
						if validemail(email) && x.split(";")[2..-1].join(";").to_s != ""
							pass = x.split(";")[2..-1].join(";") if x.split(";")[2].to_s != ""
							newx = email+":"+pass
							pp "[SEMICLEAN3]:: #{$counter}" if $diag
							$data[:cleaned].append(newx)
							if semisplit(newx) == true
								t = 1
								return true
							else
								$data[:unknown].append(x)
							end
						end
					end
					if x.split("|").length == 3
						email = x.split("|")[1]
						if validemail(email) && x.split("|")[2..-1].join("|").to_s != ""
							pass = x.split("|")[2..-1].join("|") if x.split("|")[2].to_s != ""
							newx = email+":"+pass
							pp "[PIPECLEAN3]:: #{$counter}" if $diag
							$data[:cleaned].append(newx)
							if pipesplit(newx) == true
								t = 1
								return true
							else
								$data[:unknown].append(x)
							end
						end
					end
					if x.split("\t").length == 3
						email = x.split("\t")[1]
						if validemail(email) && x.split("\t")[2..-1].join("\t").to_s != ""
							pass = x.split("\t")[2..-1].join("\t") if x.split("\t")[2].to_s != ""
							newx = email+":"+pass
							pp "[TABCLEAN3]:: #{$counter}" if $diag
							$data[:cleaned].append(newx)
							if tabsplit(newx) == true
								t = 1
								return true
							else
								$data[:unkwnow].append(x)
							end
						end
					end
					if x.split(":").length == 2
						email = x.split(":")[0]
						if validemail(email) && x.split(":")[1..-1].join(":").to_s != ""
							pass = x.split(":")[1..-1].join(":") if x.split(":")[1].to_s != ""
							newx = email+":"+pass
							pp "[COLONCLEAN2]:: #{$counter}" if $diag
							$data[:cleaned].append(newx)
							if colonsplit(x) == true
								t = 1
								return true
							else
								$data[:unkwnow].append(x)
							end
						end
					end
					if x.split(";").length == 2
						email = x.split(";")[0]
						if validemail(email) && x.split(";")[1..-1].join(";").to_s != ""
							pass = x.split(";")[1..-1].join(";") if x.split(";")[1].to_s != ""
							newx = email+":"+pass
							pp "[SEMICLEAN2]:: #{$counter}" if $diag
							$data[:cleaned].append(newx)
							if semisplit(x) == true
								t = 1
								return true
							else
								$data[:unkwnow].append(x)
							end
						end
					end
					if x.split("|").length == 2
						email = x.split("|")[0]
						if validemail(email) && x.split("|")[1..-1].join("|").to_s != ""
							pass = x.split("|")[1..-1].join("|") if x.split("|")[1].to_s != ""
							newx = email+":"+pass
							pp "[PIPECLEAN2]:: #{$counter} - #{x}" if $diag
							$data[:cleaned].append(newx)
							if pipesplit(x) == true
								t = 1
								return true
							else
								$data[:unkwnow].append(x)
							end
						end
					end
					if x.split("\t").length == 2
						email = x.split("\t")[0]
						if validemail(email) && x.split("\t")[1..-1].join("\t").to_s != ""
							pass = x.split("\t")[1..-1].join("\t") if x.split("\t")[1].to_s != ""
							newx = email+":"+pass
							pp "[TABCLEAN2]:: #{$counter}" if $diag
							$data[:cleaned].append(newx)
							if tabsplit(x) == true
								t = 1
								return true
							else
								$data[:unkwnow].append(x)
							end
						end
					end
					t = 1
				end
				if not validemail(email) 
					if $data[:badstart].length >= $wsize
						$data[:badstart].append(x)
						puts "[BADCHARWRITER2]:: #{$counter}"
						IO.write(File.join($base,"badstart.txt"),$data[:badstart].join("\n"), mode: 'a')
						$data[:badstart] = []
					else
						$data[:badstart].append(x)
					end
					return true
				end
			end
		end
	end
	if validemail(if x.split("\t").length == 2; x.split("\t")[0]; end)
		$data[:cleaned].append(x.split("\t")[0]+":"+x.split("\t")[1..-1].join("\t"))
		pp "[TAB2]:: #{$counter}" if $diag
		if tabsplit(x) == true
			return true
		else
			$data[:unkwnow].append(x)
		end
	end
	if validemail(if x.split("\t").length == 3; x.split("\t")[1]; end)
		$data[:cleaned].append(x.split("\t")[1]+":"+x.split("\t")[2..-1].join("\t"))
		pp "[TAB3]:: #{$counter}" if $diag
		if tabsplit(x.split("\t")[1]+"\t"+x.split("\t")[2..-1].join("\t")) == true
			return true
		else
			$data[:unkwnow].append(x)
		end
	end
	if validemail(if x.split(":").length >= 2; x.split(":")[0]; end)
		$data[:cleaned].append(x)
		pp "[COLON2]:: #{$counter}" if $diag
		if colonsplit(x) == true
			return true
		else
			$data[:unkwnow].append(x)
		end
	end
	if validemail(if x.split(":").length == 3; x.split(":")[1]; end)
		$data[:cleaned].append(x.split(":")[1]+":"+x.split(":")[2..-1].join(":"))
		pp "[COLON3]:: #{$counter}" if $diag
		if colonsplit(x.split(":")[1]+":"+x.split(":")[2..-1].join(":")) == true
			return true
		else
			$data[:unkwnow].append(x)
		end
	end
	if validemail(if x.split(";").length >= 2; x.split(";")[0]; end)
		$data[:cleaned].append(x.split(";")[0]+":"+x.split(";")[1..-1].join(";"))
		pp "[SEMI2]:: #{$counter}" if $diag
		if semisplit(x) == true
			return true
		else
			$data[:unkwnow].append(x)
		end
	end
	if validemail(if x.split(";").length == 3; x.split(";")[1]; end)
		$data[:cleaned].append(x.split(";")[1]+";"+x.split(";")[2..-1].join(";"))
		pp "[SEMI3]:: #{$counter}" if $diag
		
		if semisplit(x.split(";")[1]+";"+x.split(";")[2..-1].join(";")) == true
			return true
		else
			$data[:unkwnow].append(x)
		end
	end
	if validemail(if x.split("|").length >= 2;x.split("|")[0]; end)
		$data[:cleaned].append(x.split("|")[0]+":"+x.split("|")[1..-1].join("|"))
		pp "[PIPE2]:: #{$counter}" if $diag
		if pipesplit(x) == true
			return true
		else
			$data[:unkwnow].append(x)
		end
	end
	if validemail(if x.split("|").length == 3; x.split("|")[1]; end)
		$data[:cleaned].append(x.split("|")[1]+":"+x.split("|")[2..-1].join("|"))
		pp "[PIPE3]:: #{$counter}" if $diag
		if pipesplit(x.split("|")[1]+"|"+x.split("|")[2..-1].join("|")) == true
			return true
		else
			$data[:unkwnow].append(x)
		end
	end
end
def tabsplit(x)
	if x.split("\t").length >=2
		if $data[:tabbed].length >= $wsize
			$data[:tabbed].append(x)
			puts "[TABWRITER]:: #{$counter}"
			IO.write(File.join($base,"tabbed.txt"), $data[:tabbed].join("\n"), mode: 'a')
			$data[:tabbed] = []
		else
			$data[:tabbed].append(x)
		end
		return true
	end
end
def pipesplit(x)
	if x.split("|").length >=2
		if $data[:pipe].length >= $wsize
			$data[:pipe].append(x)
			puts "[PIPEWRITER]:: #{$counter}"
			IO.write(File.join($base,"pipe.txt"), $data[:pipe].join("\n"), mode: 'a')
			$data[:pipe] = []
		else
			$data[:pipe].append(x)
		end
		return true
	end
end
def semisplit(x)
	if x.split(";").length >=2
		if $data[:semi].length >= $wsize
			$data[:semi].append(x)
			puts "[SEMIWRITER]:: #{$counter}"
			IO.write(File.join($base,"semi.txt"), $data[:semi].join("\n"), mode: 'a')
			$data[:semi] = []
		else
			$data[:semi].append(x)
		end		
		return true
	end
end
def colonsplit(x)
	if x.split(":").length >=2
		if $data[:colon].length >= $wsize
			$data[:colon].append(x)
			puts "[COLONWRITER]:: #{$counter}"
			IO.write(File.join($base,"colon.txt"), $data[:colon].join("\n"), mode: 'a')
			$data[:colon] = []
		else
			$data[:colon].append(x)
		end				
		return true
	end
end
def emailsplit(x)
	if [':',';','|'].include? x[-1].to_s
		if $data[:email].length >= $wsize
			$data[:email].append(x)
			puts "[EMAILWRITER]:: #{$counter}"
			IO.write(File.join($base,"email.txt"), $data[:email].join("\n"), mode: 'a')
			$data[:email] = []
		else
			$data[:email].append(x)
		end		
		return true
	end
end
def unknown(x)	
	if $data[:unknown].length >= $wsize
		$data[:unknown].append(x)
		puts "[UNKNOWNWRITER]:: #{$counter}"
		IO.write(File.join($base,"unknown.txt"), $data[:unknown].join("\n"), mode: 'a')
		$data[:unknown] = []
	else
		$data[:unknown].append(x)
	end		
end
puts banner
initial
IO.foreach($infile) {|x|
	$counter +=1
	x=x.strip()
	if checkfirst(x) == true
		next
	end
	if emailsplit(x) == true
		next
	end
	pp "[EOF UNKNOWN]:: #{x}" if $diag
	if unknown(x) == true
		next
	end
}
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
puts "[EXIT]:: Application Finished"
