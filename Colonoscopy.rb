banner = "
     lXMMXk:.                                                   ,Kx,
       .ckNMMNx:.                                               :0MMK;
           'lOWMMKd,                                              '0MMx
               ,oKMMM0l'                                    .'.     xMMd
                  .;dKMMWOl'                     ..,.......:MMo      0MM'
                      .;xXMMWOc.              :;:o,;c;:;l:'xMM:dolccclxk:
                        ,xWMM0c.              ,:'.'.'..   :MM0.,:cccoxxoo:.
                     'dNMMKl.                            lWMX.       odooddd:
                  'dNMMKl.                            .cKMMk        kMMc .odok:
               ,dXMM0l.                     .:c;;;:lxKMMNd.       ;XMWl     ldlk.
            ,xNMM0c.                     .c0MMMMMMMWKkl'      .;dNMMk.       .klk;
         'dNMMKl.                     .c0MMWx, ...   .lKNK00XWMMM0l.           klO,
       ,KMMKl.                      :OMMWk;       .lKMMNxxxxdo:'                O:0.
      dMM0'                     .cOWMNx;       'dKMMXd'                         .0ck
     ;MMO                    .c0MMNx,       'dNMMXo.                             llO'
     dMM,                 .cOMMWk,       'oXMMXo.                                .Kcd
     lMMl                 dWMMK.      .oXMMXo.                                    k:K
     .XMW;                 .xWMWo   lXMMXo'                                       :ok'
      .kMM0;                 .dWMWd..dWMNl                                        .0cl
        .kMMK;                  oWMWx. oWMWo                                       0:0
          .kMMK;                  oWMWx. oWMWo                                     oc0.
            .kMMK;                  oWMWx. oWMWo                                   .0cd
              .xWMX:                  lNMWx. lNMWd.                                 dlO'
                .xWMNc                  cNMMk. cNMMk.                                Ock;
                  .xWMNc                  cNMMk. :KMMk.                               odddc,..
                    .xWMNc                  cNMMk' ;KMMk.                              .lldxxx.
                      .xWMNc                  cNMM0, ;KMMk.                                ..'
                        .dWMNl                  :KMM0; ;0MMO'
                           oWMWo                  ,0MMK, ,0MM0,
                             oWMWo                  ,0MMx  ,0MM0,
                               oWMWo                  xMMo   ,0MM0.
                                 lNMWd.                WMK     ,XMW'
                                   cNMWx.             .WMK      'MM0		[CodeName]:	Colonoscopy
                                     cNMWx.          .0MM:       XMX		[Produced]:	illMob - Q1/2019
                                       cNMWx'      .oNMW:       ;MMk		[Moto/PSA]:	Get yo shit checked!
                                         cXMMWKOO0NMMMk.       lWMX.
                                           .;ldxxxokWMWOo:;:lkNMWd.
                                                     ;d0NMMMWXk:
-------------------------------------------------------------------------------
[Initialize]
"

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
