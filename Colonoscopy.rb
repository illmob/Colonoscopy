# [DEVELOPER] #################################################################
#
# illnmob, cause you didn't even try to make it
#
# [requirements] ##############################################################
#
# Application does require the following gems
#  tar:: gem inststall tar
#  zlib:: gem install zlib
#  ipaddr:: gem install ipaddr
#  optparse:: gem install optparse
#  ostruct:: gem install ostruct
#
###############################################################################
#
# TODO:
#   :-- Researcher Operations (Re|Trace)
#     :-- ElasticSearch integration (should  be simple)
#       :-- Kibana Dashboards (would be awesome)
#       :-- Backup and updating functionality (unknown)
#   :-- Input types [csv,sql,(l0|O)phcrack,JTR,XLS] (binary files)
#     :-- Check file Magic # to determine type (Compressed|Zipped|Word|Imposters)
#   :-- Table inspector (Deterministic on cost**time * effort / willingness for public release)
###############################################################################
require 'zlib'
require 'tar/reader'
require 'digest'
require 'ipaddr'
require 'securerandom'
require 'optparse'  # ensure module is included with the script
require 'ostruct'  # ensure module is included with the script
require 'iconv' unless String.method_defined?(:encode)
#[User Arguments] ##############################] User Args [###########################################################
def userargs
 begin  # Catch/Rescue block start
  $options = OpenStruct.new  # create a new OpenStruct object
  OptionParser.new do |opt|
   opt.on('-t','--type TYPE','Consume all files of type ["TXT","GZ"] in a directory') { |o|
    $options[:type] = o }  # consumes all files of given within a given directory
   opt.on('-i','--input FILE/FOLDER','location of file(s) to process') { |o|
    $options[:input] = o }  # create files in directory given by user, default if not given
   opt.on('-e','--explode','Explode contents of "tar.gz" files to disk') { |o|
    $options[:explode] = o }  # create files from compressed file in directory given by user, default if not given
   opt.on('-o','--output{=FOLDERNAME}','Location on disk to store contents generated') { |o|
    $options[:folder] = o }  # location (folder) where to store the generated output
   opt.on('-d','--debug','Enables debugging information to be displayed, performance hit') { |o|
    $options[:debug] = o }  # enabled debugging output, performance hit
   opt.on('-v','--verbose','Adds additional information to STDOUT, performance hit increases') { |o|
    $options[:verbose] = o }  # adds additional debugging information to STDOUT, greater performance hit
  end.parse!  # Stop parsing options from user @ cli
 rescue => someerror  # catch error to var
  puts "[ERROR]:: OptionsParser fault: #{someerror}"
 end  # Catch/Rescue block end
end
# [banvars] ######################################################################
ct  = "\x09\x09\x5b\x43\x6f\x64\x65\x4e\x61\x6d\x65\x5d\x3a\x09\x43\x6f"
ct += "\x6c\x6f\x6e\x6f\x73\x63\x6f\x70\x79"
pt  = "\x09\x09\x5b\x50\x72\x6f\x64\x75\x63\x65\x64\x5d\x3a\x09\x69\x6c"
pt += "\x6c\x4d\x6f\x62\x20\x2d\x20\x51\x31\x2f\x32\x30\x31\x39"
gt  = "\x09\x09\x5b\x4d\x6f\x74\x6f\x2f"
gt += "\x50\x53\x41\x5d\x3a\x09\x47\x65\x74\x20\x79\x6f\x20\x73\x68\x69"
gt += "\x74\x20\x63\x68\x65\x63\x6b\x65\x64\x21"
aa  = "\x20\x3c\x3a\x43\x3b\x30\x3a\x7c\x3a\x30\x3b\x6e\x3a\x4f\x24\x3a\x43\x3a\x30\x3b\x50\x3a\x59\x2e\x5c"
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
s   = "\x20" 
h   = "-"
# [banner] ####################################################################
banner = []  # Create the banner
banner.append(h*80)
banner.append(s*5+"lXMMXk:."+s*51+",Kx,")
banner.append(s*7+".ckNMMNx:."+s*47+":0MMK;")
banner.append(s*11+"'lOWMMKd,"+s*46+"'0MMx")
banner.append(s*15+",oKMMM0l'"+s*36+".'."+s*5+"xMMd")
banner.append(s*18+".;dKMMWOl'"+s*22+af+s*6+"0M.\\")
banner.append(s*23+".;xXMMWOc."+s*17+aa)
banner.append(s*25+",xWMM0c."+s*15+",:'.'.'.."+s*3+ag)
banner.append(s*22+"'dNMMKl."+s*28+"lWMX."+s*7+"odooddd:")
banner.append(s*18+"'dNMMKl."+s*28+".cKMMk"+s*8+"kMMc"+s*1+".odok:")
banner.append(s*15+",dXMM0l."+s*21+".:c;;;:lxKMMNd."+s*7+";XMWl"+s*5+"ldlk.")
banner.append(s*12+",xNMM0c."+s*21+ah+s*6+".;dNMMk."+s*7+".klk;")
banner.append(s*9+"'dNMMKl."+s*21+".c0MMWx,"+s*1+"."*3+s*3+ak+s*12+"klO,")
banner.append(s*7+",KMMKl."+s*22+":OMMWk;"+s*7+ak+s*16+"O:0.")
banner.append(s*7+"dMM0'"+s*21+".cOWMNx;"+s*6+".'dKMMXd'"+s*25+".0ck")
banner.append(s*5+";MMO"+s*20+".c0MMNx,"+s*7+"'dNMMXo."+s*30+"llO'")
banner.append(s*6+"dMM,"+s*17+".cOMMWk,"+s*7+"'oXMMXo."+s*32+".Kcd")
banner.append(s*6+"lMMl"+s*17+"dWMMK."+s*6+".oXMMXo."+s*36+"k:K")
banner.append(s*6+".XMW;"+s*17+".xWMWo"+s*3+"lXMMXo'"+s*39+":ok'")
banner.append(s*7+".kMM0;"+s*17+".dWMWd"+s*2+"dWMNl"+s*40+".0cl")
banner.append(s*9+aj+s*18+"oWMWx."+s*1+ai+s*38+"0:0")
banner.append(s*10+".kMMK;"+s*18+"oWMWx."+s*1+ai+s*37+"oc0.")
banner.append(s*12+".kMMK;"+s*18+"oWMWx."+s*1+ai+s*35+".0cd")
banner.append(s*14+".xWMX:"+s*18+"lNMWx."+s*1+"lNMWd."+s*33+"dlO'")
banner.append(s*16+".xWMNc"+s*18+"cNMMk."+s*1+"cNMMk."+s*32+"Ock;")
banner.append(s*18+".xWMNc"+s*18+"cNMMk."+s*1+":KMMk."+s*31+"odddc,..")
banner.append(s*20+".xWMNc"+s*18+"cNMMk'"+s*1+";KMMk."+s*30+".lldxxx.")
banner.append(s*22+".xWMNc"+s*18+"cNMM0,"+s*1+";KMMk."+s*32+"..'")
banner.append(s*24+".dWMNl"+s*18+":KMM0;"+s*1+";0MMO'")
banner.append(s*27+ai+s*18+",0MMK,"+s*1+",0MM0,")
banner.append(s*29+ai+s*18+",0MMx"+s*1+",0MM0,")
banner.append(s*31+ai+s*18+"xMMo"+s*3+",0MM0.")
banner.append(s*33+"lNMWd."+s*16+"WMK"+s*5+",XMW'")
banner.append(s*35+"cNMWx."+s*13+".WMK"+s*6+"'MM0"+ct)
banner.append(s*37+"cNMWx."+s*10+".0MM:"+s*7+"XMX"+pt)
banner.append(s*39+"cNMWx'"+s*6+".oNMW:"+s*7+";MMk"+gt)
banner.append(s*42+ac+s*7+"lWMX.")
banner.append(s*44+ad)
banner.append(s*53+ae)
banner.append(h*80)
# [initial] ###################################################################
def initial
 puts "[INITIALIZER]:: Application initialized"
 $directory_name = "evidence"
 puts "[INITIAL]:: Entering"+(if $verb; "[INITIAL]:: Default DIR name: #{$directory_name}"; end) if $diag
 begin
  begin
    if $options[:debug]; $diag = true; puts "[OPTIONS]:: OptionsParser: PASSED"; else; $diag = false; end  # Accept user argument for debugging
    if $options[:verbose]; $verb = true;  # Accept user argument for debugging in verbose mode
     puts "[OPTIONS]:: Debug: #{$diag}"; puts "[OPTIONS]:: Verbose: #{$verb}"
     puts "[OPTIONS]:: Explode: #{$options[:explode]}" if $options[:explode].to_s != ""
     puts "[OPTIONS]:: Input: #{$options[:input].to_s}" if $options[:input].to_s != ""
     puts "[OPTIONS]:: Folder: #{$options[:folder].to_s}" if $options[:folder].to_s != ""
     puts "[OPTIONS]:: Type: #{$options[:type].to_s}" if $options[:type].to_s != "" 
    else; $verb = false;
    end
  rescue => someerror  # catch error to va
   puts "[ERROR]:: Debugger/Verbose failed: #{someerror}"; exit
  end  # Catch/Rescue block end
  puts "[INITIAL]:: Initial debugging options set"
  $inilist = {:badstart => [],:quoted => [],:semi => [],:colon => [], 
  :pipe => [],:nosplit => [],:email => [],:unknown => [], 
  :tabbed => [],:cleaned => [],:upwd => [],:badconvert => []}  # Create the default hash to be used in the application
  $speclist = ["!", '"', "#", "$","%", "&", "'", "(", ")", "*",
  "+", ",","-", ".", "/", ":", ";", "<", "=", ">","?", "\,", "\\"]  # Create the default Special char list
  $skipfiles = [".",".."]  # file locations to ignore
  $splitchar = [":",";","|","\t"]  # characters known to split on
  puts "[INITIAL]:: Default HASH and Special Char list created"
  (if $verb; puts "[INITIAL]:: inilist length: #{$inilist.length}"; else ""; end) if $diag
  (if $verb; puts "[INITIAL]:: speclist length: #{$speclist.length}"; else ""; end) if $diag
  $compdata = ""  # Set global var
  (if $verb; puts"[INITIAL]:: Default compdata #{$compdata}"; else ""; end) if $diag
  $md5 = Digest::MD5.new  # Set global call for MD5 hash
  $counter = 0  #Set counter to 0
  (if $verb; puts"[INITIAL]:: Default counter #{$counter}"; else ""; end) if $diag
  $wsize = 500000  # Set write size check to half million lines
  (if $verb; puts"[INITIAL]:: Default wsize #{$wsize}"; else ""; end) if $diag
  $filesin = []  # Set default list of files to be injested
  (if $verb; puts"[INITIAL]:: Default filesin #{$filesin}"; else ""; end) if $diag
  (if $verb; puts"[INITIAL]:: Default options[:folder] #{$options[:folder]}"; else ""; end) if $diag
  if $options[:folder].to_s != ""; $directory_name = $options[:folder]; end
  #else; $directory_name = projname($options[:input].to_s); end  # Set default evidence directory
  puts "[INITIAL]:: Creating evidence directory"+(if $verb; ": #{$directory_name}"; else ""; end) if $diag
  Dir.mkdir($directory_name) unless Dir.exists?($directory_name) # Create DIR if it does not exists
  puts "[INITIAL]:: Exiting" if $diag
rescue => someerror
  puts "[INITIAL]:: FATAL ERROR:: initial module"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [mainfun] ###################################################################
def mainfun
 begin
  puts "[MAINFUN]:: Entering\n[MAINFUN]:: Setting application variables for filenames" if $diag
  ingestion  # Gather files to be processes from ingestion function
  puts "[MAINFUN]:: Examining files"+(if $verb; ": #{$filesin}"; else ""; end) if $diag
  $filesin.each { | finfile |
   puts "[MAINFUN]:: Interacting with file: #{finfile}" if $diag
   procfiles(finfile)  # Process files to generate additional global vars
   if finfile.split(".")[-1].to_s.downcase == "txt"
    puts "[MAINFUN]:: Input file is TXT" if $diag
    inoutput(finfile)  # If file is of type TXT, process singular files contents
   end
   if finfile.split(".")[-1].to_s.downcase == "gz"
    puts "[MAINFUN]:: Input file is GZ" if $diag
    tarpit(finfile)  # If file is of type GZ, inflate and process singular files contents
   end
   bufferflush  # Proceed to flush any contents that did not hit write counter limits
  }
  puts "[MAINFUN]:: Exiting" if $diag
 rescue  => someerror
  puts "[MAINFUN]:: FATAL ERROR:: mainfun module"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [ingestion] #################################################################
def ingestion
 puts "[CONSUME]:: Entering" if $diag
 $filesin = []  # Set default list of files to be consumed
 (if $verb; puts "[CONSUME]:: filesin: #{$filesin}"; else ""; end) if $diag
 begin
  (if $verb; puts "[CONSUME]:: Testing if input is a directory"; else ""; end) if $diag
  if File.directory? $options[:input].to_s
   puts "[CONSUME]:: Initial input location used"+(if $verb; ": #{$options[:input]}"; else ""; end) if $diag
   begin
    puts "[CONSUME]:: Searching directory for #{$options[:type].to_s.upcase} files:" if $diag
    foname = $options[:input]
    puts "[CONSUME]:: User options given as input"+(if $verb; ": #{foname}"; else ""; end) if $diag
    Dir.entries(foname).each { | fin | 
     if $skipfiles.include? fin.to_s
      puts "[CONSUME]:: Skipped a file from being procesed"+(if $verb; ": #{fin.to_s}"; else ""; end) if $diag
      next
     end
     if fin.split(".")[-1].to_s.downcase == $options[:type].to_s.downcase
      puts "[CONSUME]:: A file is being appended"+(if $verb; ": #{fin.to_s}"; else ""; end) if $diag
      $filesin.append(fin.to_s)
      (if $verb; puts "[CONSUME]:: filesin: #{$filesin}"; else ""; end) if $diag
     end
    }  # If user input was of a directory, include all files @ set type
    puts "[CONSUME]:: All files being processed"+(if $verb; ": #{$filesin}"; else ""; end) if $diag
   rescue => someerror
    puts "[CONSUME]:: FATAL ERROR:: ingestion module"+(if $verb; ": #{someerror}"; else ""; end) if $diag;
   end
   (if $verb; puts "[CONSUME]:: Input was a directory"; end) if $diag
  end
  (if $verb; puts "[CONSUME]:: Testing if input is a file"; end) if $diag
  if File.file? $options[:input].to_s
   # If user input was of a file. include singlular file
   $filesin.append($options[:input].to_s)
   puts "[CONSUME]:: Single"+(if $verb; ": #{$options[:type].to_s.upcase}"; else ""; end)+" file being processed"+(if $verb; ": #{$options[:input].to_s}"; else ""; end)
   (if $verb; puts "[CONSUME]:: Input was a file"; end) if $diag
  end
  return # Return the generated list of files for additional processing
 rescue => someerror
  puts "[CONSUME]:: Please enter a file.txt or directory containing .gz files"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
 puts "[CONSUME]:: Exiting" if $diag
end
# [projname] ##################################################################
def projname(project)
 begin
  puts "[PROJECT]:: Entering"+(if $verb; ": #{project}"; else ""; end) if $diag
  if project.split(".") >= 2
   prepro = project.split(".")[-2]  # Split filename and store results
  else
   prego = project
  end
  puts "[PROJECT]:: Project name modified"+(if $verb; ": #{prepro}"; else ""; end) if $diag
  prepro = prepro.split("/")[-1] if project.split("/").length >= 2  # Split directory and store results
  (if $verb; puts "[PROJECT]:: prepro #{prepro}"; else ""; end) if $diag
  prepro = prepro.split("\\")[-1] if project.split("\\").length >= 2  # Split directory and store results
  (if $verb; puts "[PROJECT]:: prepro #{prepro}"; else ""; end) if $diag
  projectname = prepro
  puts "[PROJECT]:: Project name set"+(if $verb; ": #{projectname}"; else ""; end) if $diag
 rescue => someerror
  puts "[PROJECT]:: Failed to produce project name"+(if $verb; ": #{someerror}"; else ""; end) if $diag  # generate a new project name
  projectname = SecureRandom.alphanumeric
  puts "[PROJECT]:: Generated project name"+(if $verb; ": #{someerror}"; else ""; end) if $diag  # generate a new project name
 end
 puts "[PROJECT]:: Exiting" if $diag
 return projectname  # Return the project name for additional processing
end
# [procfiles] ##################################################################
def procfiles(infile)
 begin
  puts "[PROCESS]:: Entering"+(if $verb; ": #{infile}"; else ""; end) if $diag
  project = projname(infile)  # Set porject name to generate file structure
  puts "[PROCESS]:: Project: #{project}" if $diag
  (if $verb; puts "[PROCESS]:: directory_name #{$directory_name}"; else ""; end) if $diag
  $base = File.join($directory_name, project)  # Set base DIR name to store files
  puts "[PROCESS]:: Base location set"+(if $verb; ": #{$base}"; else ""; end) if $diag;
  begin
   Dir.mkdir($base) unless Dir.exists?($base)  # Create base DIR if it does not exists
   puts "[PROCESS]:: File/Folder creation: PASSED"+(if $verb; ": #{$base}"; else ""; end) if $diag
  rescue => someerror
   puts "[PROCESS]:: File/Folder not created"+(if $verb; ": #{someerror}"; else ""; end) if $diag
  end
 rescue => someerror
  puts "[PROCESS]:: Failed to process project directories"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit  # generate files as needed
 end
 puts "[PROCESS]:: Exiting" if $diag
end
# [inoutput] ##################################################################
def inoutput(infile)
 begin
  puts "[IOREADER]:: Entering"+(if $verb; ": #{infile}"; else ""; end) if $diag
  if not $options[:input].to_s == infile.to_s
   newfile = File.join($options[:input].to_s, infile)
  else
   newfile = infile
  end
  $data = $inilist  # Set default has to global variable
  puts "[IOREADER]:: Datahash set to default"+(if $verb; ": #{$data}"; else ""; end) if $diag
  IO.foreach(newfile){ | x | if gauntlet(x) == true; next;else;if $verb; puts "[IOREADER]:: skipped test case #{x}"; else ""; end; end }  # Process each line of file
 rescue => someerror
  puts "[IOREADER]:: Failed to parse file"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit  # reading input file
 end
 puts "[IOREADER]:: Exiting" if $diag
end
# [tarpit] ####################################################################
def tarpit(infile)
 begin
  puts "[TARPIT]:: Entering"+(if $verb; ": #{infile}"; else ""; end) if $diag
  Tar::Reader.new( Zlib::GzipReader.open(infile)).each { |fzile|
   sticky = []  # default content list may change inn future
   (if $verb; puts "[TARPIT]:: Entry list set :#{sticky.length}"; else "0"; end) if $diag
   $data = $inilist  # Set default has to global variable
   (if $verb; puts "[TARPIT]:: Default datahash set: #{$data.length}"; else "0"; end) if $diag
   puts "[TARPIT]:: #{fzile.header}" if $diag
   if fzile.header.size.to_i == 0; next; end  # Skip entry if size is 0
   compfile = fzile.header.name
   puts "[TARPIT]:: Compressed file: #{compfile}"
   compfilelen = fzile.header.size
   puts "[TARPIT]:: Commiting #{compfilelen} bytes to memory, please wait" if $diag
   begin
    fzile.read.each_line {|x| sticky.append(x)}  # Read contents of commpressed file and append to list
   rescue
 	  puts "[TARPIT]:: Finished processing #{compfile}" if $diag; break
   end
   puts "[TARPIT]:: Inflated data length: #{sticky.length}" if $diag
   puts "[TARPIT]:: Proceeding to Gauntlet" if $diag;
   sticky.each { | x | if gauntlet(x) == true; next; end }  # Process each line of file
   puts "[TARPIT]:: Gauntlet  processing finished" if $diag
  }
 rescue => someerror
  puts "[TARPIT]:: Failed to parse GZ file"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit  # reading gz contents file
 end
 puts "[TARPIT]:: Exiting" if $diag
end
# [gauntlet] ##################################################################
def gauntlet(xstring)
 begin
  puts "[GUANTLET]:: Entering"+(if $verb; ": #{xstring}"; else ""; end) if $diag
  $counter +=1  # Increment counter by 1
  (if $verb; puts "[GUANTLET]:: Counter incremented #{$counter}"; else "0"; end) if $diag
  estring = encoded(xstring)  # Attempt to encode string as needed in forgine dumps
  (if $verb; puts "[GUANTLET]:: Encoded entry: #{estring} of #{xstring}"; else ""; end) if $diag
  if checkfirst(estring) == true; (if $verb; puts "[GUANTLET]:: Encoded: #{estring}"; end) if $diag; return true; 
   else; puts "[ERROR]:: Guantlet failed checkfirst: #{xstring}" if $diag; end  # Process entry through module
  if upwdsplit(estring) == true; (if $verb; puts "[GUANTLET]:: Encoded: #{estring}"; end) if $diag;; return true; 
   else; puts "[ERROR]:: Guantlet failed upwdsplit: #{xstring}" if $diag; end  # Process entry through module if failed previous
  if unknown(estring) == true; (if $verb; puts "[GUANTLET]:: Encoded: #{estring}"; end) if $diag;; return true; 
   else; puts "[ERROR]:: Guantlet failed unknown: #{xstring}" if $diag; end  # Process entry through module if failed previous, final attempt EOF
 rescue => someerror
  puts "[GUANTLET]:: Failed to run the guantlet"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit  # reading gz contents file
 end 
 puts "[GUANTLET]:: Exiting" if $diag
 return true  # Even if results are unknown return true
end
 # [checkfirst] ################################################################
def checkfirst(x)
 begin
  puts "[VALIDATOR]:: Entering"+(if $verb; ": #{x}"; else ""; end) if $diag
  if $speclist.include? x[0].to_s[0]  # Check if the leading character in entry is a Special Character
   puts "[VALIDATOR]:: Found lead character in speclist"+(if $verb; ": #{x}"; else ""; end) if $diag
   #  Check if first location after split is a valid email address or not
   if not validemail(if x.split(":").length >= 2; x.split(":")[0]; end) ||
    if not validemail(if x.split(";").length >= 2; x.split(";")[0]; end) ||
     if not validemail(if x.split("|").length >= 2; x.split("|")[0]; end) ||
      if not validemail(if x.split("\t").length >= 2; x.split("\t")[0]; end)
       puts "[VALIDATOR]:: No valid email in the first set"+(if $verb; ": #{x}"; else ""; end) if $diag
       quoted(x)  # Process entry to validate if the entry is quoted
       questions(x)  # Process entry to validate if the entry has leading "?"
 	    end
      # Future use case, if they arrise
 	   end
     # Future use case, if they arrise
    end
    # Future use case, if they arrise
   end
   # Future use case, if they arrise
  else
   puts "[VALIDATOR]:: No valid email address found, sending to decider"+(if $verb; ": #{x}"; else ""; end) if $diag
   decider(x)
  end
 rescue => someerror
  puts "[VALIDATOR]:: Failed to parse GZ file"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit  # reading gz contents file
 end
end
# [questions] ##################################################################
def decider(x)
 puts "[DECIDER]:: Entering"+(if $verb; ": #{x}"; else ""; end) if $diag
 begin
  trigger = false # Set to 0 for initial process
  (if $verb; puts "[DECIDER]:: Default trigger: #{trigger}"; else ""; end) if $diag
  while trigger == false  # Keep running until true
   begin
    (if $verb; puts "[DECIDER]:: Trigger status: #{trigger}"; else ""; end) if $diag
    puts "[DECIDER]:: Started Processing entry for catagorization" if $diag
    # Attempt to identify the structure of the entry through indepth validation routines
    $splitchar.each { | schar |
     if x.split(schar).length >= 2; if lenrun(schar,x) == true; trigger = true; puts "[DECIDER]:: split at #{schar}" if $diag; return true; end; end
    }
    puts "[DECIDER]:: Finished Processing entry for catagorization" if $diag
   rescue => someerror
    puts "[DECIDER]:: Failed at splitting, return true"+(if $verb; ": #{someerror}"; else ""; end) if $diag
    trigger = true  # Return true even in failure to stop the loop
    (if $verb; puts "[DECIDER]:: Default trigger: #{trigger}"; else ""; end) if $diag
   end
   puts "[DECIDER]:: This should never happen, return true"+(if $verb; ": #{someerror}"; else ""; end) if $diag
   trigger = true  # Return true even in failure to stop the loop
   (if $verb; puts "[DECIDER]:: Default trigger: #{trigger}"; else ""; end) if $diag
  end
  puts "[DECIDER]:: Exiting" if $diag
 rescue => someerror
  puts "[DECIDER]:: Failed to make decision"+(if $verb; ": #{someerror}"; else ""; end) if $diag
 end
end
# [questions] ##################################################################
def questions(x)
 begin
  puts "[QUESTION]:: Entering"+(if $verb; ": #{x}"; else ""; end) if $diag
  if x[0].to_s[0] == '?'  # Check if the leading character is a questionmark
   puts "[QUESTION]:: First character is a questionmark"+(if $verb; ": #{x}"; else ""; end) if $diag
   x = x.strip()  # Attempt to strip any newline character from end of entry
   puts "[QUESTION]:: Ensure input has no newline character(s)"+(if $verb; ": #{x}"; else ""; end) if $diag
   # Start spliting the entry from different known delimeters and attempt to vlaidate the string with lenrun
   if (
    $splitchar.each { |schar |
     if (
      puts "[QUESTION]:: Iterating split character"+(if $verb; ": #{schar}" ; else ""; end) if $diag
      if validemail(x.split(schar)[1])
       email = x.split(schar)[1].split(" ")[-1]
       puts "[QUESTION]:: Set email from first element"+(if $verb; ": #{email}" ; else ""; end) if $diag
       remainder =  x.split(schar)[2..-1].join(schar)
       puts "[QUESTION]:: Set remainder of string"+(if $verb; ": #{remainder}" ; else ""; end) if $diag
       newmail = email+schar+remainder
       puts "[QUESTION]:: Set new email"+(if $verb; ": #{newmail}" ; else ""; end) if $diag
       lenrun(schar,newmail)
      end
      ) == true
      puts "[QUESTION]:: Valid entry found"+(if $verb; ": #{newmail}" ; else ""; end) if $diag
      return true
     end
    }
   ) != true
    puts "[QUESTION]:: Appending to badsplit list"+(if $verb; ": #{x}"; else ""; end) if $diag
    badsplit(x)
    return true
   end
   puts "[QUESTION]:: Exiting" if $diag
  end
 rescue => someerror
  puts "[QUESTION]:: Failed to make process input"+(if $verb; ": #{someerror}"; else ""; end) if $diag
 end
end
 # [encoded] ##################################################################
def encoded(plainstring)
 begin
  puts "[ENCODEX]:: Entering"+(if $verb; ": #{plainstring}"; else ""; end) if $diag
  begin
   # Attempt to remove newline characters from entry and return results
   encodedstring = plainstring.strip()  # Removes newline character with standard ruby strip
   puts "[ENCODEX]:: Generic Strip newline from #{encodedstring}" if $diag
  rescue => someerror
   puts "[ENCODEX]:: Failed to strip newline from from string"+(if $verb; ": #{someerror}"; else ""; end) if $diag
   begin
    encodedstring = convert8string(plainstring).strip()  # Standard converstion for Standard English
    puts "[ENCODEX]:: Encode string in utf8 #{encodedstring}" if $diag
   rescue => someerror
     puts "[ENCODEX]:: Failed encode string in utf8"+(if $verb; ": #{someerror}"; else ""; end) if $diag
    begin
     encodedstring =  conver16string(plainstring).strip()  # Can happen with Arabic/Chines chars
     puts "[ENCODEX]:: Encode string in utf16 #{encodedstring}" if $diag
    rescue => someerror
     puts "[ENCODEX]:: Failed encode string in utf16"+(if $verb; ": #{someerror}"; else ""; end) if $diag
     begin
      encodedstring = utf821628(plainstring).strip()  # Only happens when difficult to encode entries are present (China)
      puts "[ENCODEX]:: Encode string UTC8=>16=>8 #{encodedstring}" if $diag
     rescue => someerror
      puts "[ENCODEX]:: Failed encode string in UTF8=>16=>8"+(if $verb; ": #{someerror}"; else ""; end) if $diag
     end
     puts "[ENCODEX]:: Exiting" if $diag
     return encodedstring
    end
    puts "[ENCODEX]:: Exiting" if $diag
    return encodedstring  
   end
   puts "[ENCODEX]:: Exiting" if $diag
   return encodedstring
  end
  puts "[ENCODEX]:: Exiting" if $diag
  return encodedstring
 rescue => someerror
  puts "[ENCODEX]:: Failed to encodes input"+(if $verb; ": #{someerror}"; else ""; end) if $diag
 end
end
# [lenrun] ####################################################################
def lenrun(char, x)
 begin
  puts "[LENRUN]:: Entering"+(if $verb; ": #{char}, #{x}"; else ""; end) if $diag
  if x.split(char).length >= 2  # If split results in a length of 2 or more
   puts "[LENRUN]:: Passed length requirement"+(if $verb; ":#{x.split(char).length}"; else ""; end) if $diag
   if x.split(char).length == 2  # If split is exact length, process further and validate entries
    puts "[LENRUN]:: Entry is exact"+(if $verb; ":#{x.split(char).length}"; else ""; end) if $diag
    set1 = x.split(char)[0]; set2 = x.split(char)[1]  # split and set positions based on length, and validate
    puts "[LENRUN]:: Split entry in parts"+(if $verb; ": #{set1}, #{set2}"; else ""; end) if $diag
    if validemail(set1) != true && if validemail(set2) != true; puts "[USPWD]:: NO VALID EMAILS FOUND: #{x} #{$counter}" if $diag; upwdsplit(x); return true; end; end
    if validemail(set1) == true; $newx = set1+char+set2; puts "[LENRUN]:: Valid set1 #{set1}" if $diag; end
    if validemail(set2) == true; $newx = set2+char+set1; puts "[LENRUN]:: Valid set2 #{set2}" if $diag; end
    puts "[LENRUN]:: Combined new entry"+(if $verb; ": #{$newx}"; else ""; end) if $diag
   end
  end
  if x.split(char).length >= 3  # If split results in a length of3 or more
   puts "[LENRUN]:: Entry is exact"+(if $verb; ":#{x.split(char).length}"; else ""; end) if $diag
   set1 = x.split(char)[0]; set2 = x.split(char)[1]; set3 = x.split(char)[2]  # split and set positions based on length, and validate
   puts "[LENRUN]:: Split entry in parts"+(if $verb; ": #{set1}, #{set2}, #{set3}"; else ""; end) if $diag
   if validemail(set1) != true && if validemail(set2) != true && if validemail(set3) != true || if validemail(set4) != true; unknown(x);
   puts "[USPWD]:: NO VALID EMAILS FOUND: #{x} #{$counter}" if $diag; return true; end; end; end; end
   if x.split(char).length > 3; set4 = ":"+x.split(char)[3..-1].join(char); else; set4 = ""; end
   if validemail(set1) == true && if validemail(set2) != true || if validemail(set3) != true; 
    $newx = set1+char+set2+char+set3+set4; puts "[LENRUN]:: Valid set1 #{set1}" if $diag; end; end; end
   if validemail(set2) == true && if validemail(set1) != true || if validemail(set3) != true; 
    $newx = set2+char+set1+char+set3+set4; puts "[LENRUN]:: Valid set2 #{set2}" if $diag; end; end; end
   if validemail(set3) == true && if validemail(set1) != true || if validemail(set2) != true; 
    $newx = set3+char+set1+char+set2+set4; puts "[LENRUN]:: Valid set3 #{set3}" if $diag; end; end; end
   puts "[LENRUN]:: Combined new entry"+(if $verb; ": #{$newx}"; else ""; end) if $diag 
  end
  if $newx.to_s != ""  # as long as newx is not blank
   $data[:cleaned].append($newx)  # Append newx to cleaned list of known good sets
   puts "[LENRUN]:: Append newx to clean list"+(if $verb; ": #{$newx}"; else ""; end) if $diag
   # Attempt to have entry parsed into respective entry list
   if char.to_s == "\t"; if tabsplit($newx) == true;   puts "[LENRUN]:: TABBED - #{$newx} #{$counter}" if $diag; return true; end; end
   if char.to_s == ":";  if colonsplit($newx) == true; puts "[LENRUN]:: COLON - #{$newx} #{$counter}" if $diag; return true; end; end
   if char.to_s == ";";  if semisplit($newx) == true;  puts "[LENRUN]:: SEMI - #{$newx} #{$counter}" if $diag; return true; end; end
   if char.to_s == "|";  if pipesplit($newx) == true;  puts "[LENRUN]:: PIPE - #{$newx} #{$counter}" if $diag; return true; end; end
  else  # if entry does not quantify into its repsective list, add entry to unkwown list
   unknown(x)
   puts "[LENRUN]:: NO VALID FORMATS FOUND: #{x} #{$counter}" if $diag
   return true
  end
  puts "[LENRUN]:: Exiting" if $diag
 rescue => someerror
  puts "[LENRUN]:: Failed to run length of input"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
 return
end
# [quoted] ##################################################################
def quoted(x)  # Checks if entry is quoted of not
 puts "[QUOTED]:: Entering"+(if $verb; ": #{x}"; else ""; end) if $diag
 begin
  if x[0].to_s[0] == '"'
	 puts "[QUOTED]:: Append to Quoted list" if $diag
	 quotesplit(x)  # If entry is quotes, run entry through respective parser
	end
 rescue => someerror
  puts "[QUOTED]:: Failed to identify quoted content"+(if $verb; ": #{someerror}"; else ""; end) if $diag
 end
 puts "[QUOTED]:: Exiting" if $diag
end
# [makehash] ##################################################################
def makehash(datain)  # Returns a MD5 hash of given dataset
 begin
  puts "[MAKEHASH]:: Entering"+(if $verb; ": #{datain}"; else ""; end) if $diag
  newhash = $md5.update(datain).hexdigest
  puts "[MAKEHASH]:: New hash"+(if $verb; ": #{newhash}"; else ""; end) if $diag
  $md5.reset  # Reset for any additional use after completion
  puts "[MAKEHASH]:: Exiting" if $diag
  return newhash
rescue => someerror
  puts "[MAKEHASH]:: Failed producing MD5 sum"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [validemail] ################################################################
def validemail(email)  # Check if entry is a valid email address
 begin
  puts "[VALIDMAIL]:: Entering" +(if $verb; ": #{email}"; else ""; end) if $diag
  if /.+@.+\..+/i.match(email); return true; end
  puts "[VALIDMAIL]:: Email validated"+(if $verb; ": #{email}"; else ""; end) if $diag
  puts "[VALIDMAIL]:: Exiting" if $diag
 rescue => someerror
  puts "[VALIDMAIL]:: Failed in validating email"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [valid4ip] ################################################################
def valid4ip(address)  # Check if entry is a valid ipv4 address
 begin
  puts "[VALIDIPV4]:: Entering"+(if $verb; ": #{address}"; else ""; end) if $diag
  ip = IPAddr.new(address)
  if ip.ipv4?; puts "[VALIDIPV4]:: IPv4 validated"+(if $verb; ": #{address}"; else ""; end) if $diag; return true; end
  puts "[VALIDIPV4]:: Exiting" if $diag
 rescue => someerror
  puts "[VALIDIPV4]:: Failed in ipv4 validation"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [valid6ip] ################################################################
def valid6ip(address)  # Check if entry is a valid ipv6 address
 begin
  puts "[VALIDIPV6]:: Entering"+(if $verb; ": #{address}"; else ""; end) if $diag
  ip = IPAddr.new(address)
  if ip.ipv6?; puts "[VALIDIPV6]:: IPv6 validated"+(if $verb; ": #{address}"; else ""; end) if $diag; return true; end
  puts "[VALIDIPV6]:: Exiting" if $diag
 rescue => someerror
  puts "[VALIDIPV6]:: Failed in ipv6 validation"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [convert8string] ################################################################
def convert8string(str1)  # Convert entry into UTF8
 begin
  puts "[UTF*STR]:: Entering"+(if $verb; ": #{str1}"; else ""; end) if $diag
  if String.method_defined?(:encode)
   str2 = str1.encode!('UTF-8', :invalid => :replace, :replace => '')
   puts "[UTF*STR]:: Str UTF8 validated"+(if $verb; ": #{str2}"; else ""; end) if $diag
   return str2
  else
   ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
   str2 = ic.iconv(str1)
   puts "[UTF*STR]:: Str UTF8+IGNORE validated"+(if $verb; ": #{str2}"; else ""; end) if $diag
   return str2
  end
  puts "[UTF*STR]:: Exiting" if $diag
 rescue => someerror
  puts "[UTF*STR]:: Failed in convert UFT 8 string validation"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [convert16string] ################################################################
def convert16string(str1)  # Convert entry from UTF8 into UTF16
 begin
  puts "[UTF*STR]:: Entering"+(if $verb; ": #{str1}"; else ""; end) if $diag
  if String.method_defined?(:encode)
   str2 = str1.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
   puts "[UTF*STR]:: Str UTF16 validated"+(if $verb; ": #{str2}"; else ""; end) if $diag
   return str2
  else
   ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
   str2 = ic.iconv(str1)
   puts "[UTF*STR]:: Str UTF8+IGNORE validated"+(if $verb; ": #{str2}"; else ""; end) if $diag
   return str2
  end
  puts "[UTF*STR]:: Exiting" if $diag
 rescue => someerror
  puts "[UTF*STR]:: Failed in convert UTF16 string validation"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [utf821628] ################################################################
def utf821628(str1)  # Convert entry from UTF8 into UTF16 and back into UTF8
 begin
  puts "[UTF*STR]:: Entering"+(if $verb; ": #{str1}"; else ""; end) if $diag
  if String.method_defined?(:encode)
   str2 = str1.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
   str3 = str2.encode!('UTF-8', 'UTF-16')
   puts "[UTF*STR]:: Str UTF16/8/16 validated"+(if $verb; ": #{str3}"; else ""; end) if $diag
   return str3
  else
   ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
   str2 = ic.iconv(str1)
   puts "[UTF*STR]:: Str UTF16/8/16 validated"+(if $verb; ": #{str2}"; else ""; end) if $diag
   return str2
  end
  puts "[UTF*STR]:: Exiting" if $diag
 rescue => someerror
  puts "[UTF*STR]:: Failed in convert 8 into 16 into string validation"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [badsplit] ##################################################################
def badsplit(x)  # create entry if string did not split
 begin
  puts "[BADCHARWRITER]:: Entering"+(if $verb; ": #{x}"; else ""; end) if $diag
  if $data[:badstart].length >= $wsize
   $data[:badstart].append(x)
   puts "[BADCHARWRITER]:: #{$counter}"
   IO.write(File.join($base,"badstart.txt"),$data[:badstart].join("\n"), mode: 'a')
   $data[:badstart] = []
  else
   puts "[BADCHAR]:: #{x}"
   $data[:badstart].append(x)
  end
  puts "[BADCHARWRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[BADCHARWRITER]:: Failed to write badchar list"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [tabsplit] ##################################################################
def tabsplit(x)  # Attempt to split entry with tab
 begin
  puts "[TAB\\tWRITER]:: Entering"+(if $verb; ": #{x}"; else ""; end) if $diag
  if $data[:tabbed].length >= $wsize
   puts "[TAB\\tWRITER]:: #{$counter}"
   IO.write(File.join($base,"tabbed.txt"), $data[:tabbed].join("\n"), mode: 'a')
   $data[:tabbed] = []
   $data[:tabbed].append(x)
  else
   $data[:tabbed].append(x)
  end
  puts "[TAB\\tWRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[TAB\\tWRITER]:: Failed to write tabbed list"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [quotesplit] #################################################################
def quotesplit(x)  # Add entry into quoted list
 begin
  puts "[QUOTEWRITER]:: Entering"+(if $verb; ": #{x}"; else ""; end) if $diag
  if $data[:quoted].length >= $wsize
   $data[:quoted].append(x)
   puts "[QUOTEWRITER]:: #{$counter}"
   IO.write(File.join($base,"quoted.txt"), $data[:quoted].join("\n"), mode: 'a')
   $data[:quoted] = []
  else
   puts "[QUOTEWRITER]:: #{x}"
   $data[:quoted].append(x)
  end
  puts "[QUOTEWRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[QUOTEWRITER]:: Failed to quoted list"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [pipesplit] #################################################################
def pipesplit(x)  # Attempt to split entry with pipe
 begin
  puts "[PIPE|WRITER]:: Entering"+(if $verb; ": #{x}"; else ""; end) if $diag
  if $data[:pipe].length >= $wsize
   puts "[PIPE|WRITER]:: #{$counter}"
   IO.write(File.join($base,"pipe.txt"), $data[:pipe].join("\n"), mode: 'a')
   $data[:pipe] = []
   $data[:pipe].append(x)
  else
   $data[:pipe].append(x)
  end
  puts "[PIPE|WRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[PIPE|WRITER]:: Failed to pipe list"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [semisplit] #################################################################
def semisplit(x)  # Attempt to split entry with semicolon
 begin
  puts "[SEMI;WRITER]:: Entering"+(if $verb; ": #{x}"; else ""; end) if $diag
  if $data[:semi].length >= $wsize
   puts "[SEMI;WRITER]:: #{$counter}"
   IO.write(File.join($base,"semi.txt"), $data[:semi].join("\n"), mode: 'a')
   $data[:semi] = []
   $data[:semi].append(x)
  else
   $data[:semi].append(x)
  end
  puts "[SEMI;WRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[SEMI;WRITER]:: Failed to semicolon list"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [colonsplit] ################################################################
def colonsplit(x)  # Attempt to split entry with colon
 begin
  puts "[COLO:WRITER]:: Entering"+(if $verb; ": #{x}"; else ""; end) if $diag
  if $data[:colon].length >= $wsize
   puts "[COLO:WRITER]:: #{$counter}"
   IO.write(File.join($base,"colon.txt"), $data[:colon].join("\n"), mode: 'a')
   $data[:colon] = []
   $data[:colon].append(x)
  else
   $data[:colon].append(x)
  end
  puts "[COLO:WRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[COLO:WRITER]:: Failed to colon list"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [unknown] ###################################################################
def unknown(x)   # Add entry to unkwown list
 begin
  puts "[KNOW?WRITER]:: Entering"+(if $verb; ": #{x}"; else ""; end) if $diag
  if $data[:unknown].length >= $wsize
   puts "[KNOW?WRITER]:: #{$counter}"
   IO.write(File.join($base,"unknown.txt"), $data[:unknown].join("\n"), mode: 'a')
   $data[:unknown] = []
   $data[:unknown].append(x)
  else
   $data[:unknown].append(x)
  end
  puts "[KNOW?WRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[KNOW?WRITER]:: Failed to unknown list"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [upwdsplit] #################################################################
def upwdsplit(x)  # Add entry into username and password list
 begin
  puts "[UPWDWRITER]:: Entering"+(if $verb; ": #{x}"; else ""; end) if $diag
  if $data[:upwd].length.to_i >= $wsize
   puts "[UPWDWRITER]:: #{$counter}"
   IO.write(File.join($base,"userpass.txt"), $data[:upwd].join("\n"), mode: 'a')
   $data[:upwd] = []
   $data[:upwd].append(x)
  else
   $data[:upwd].append(x)
  end
  puts "[UPWDWRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[UPWDWRITER]:: Failed to userpass list"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [bufferflush] ###############################################################
def bufferflush  # Write any left over contents within the $data hash
 begin
  puts "[FINAL]:: Entering" if $diag
  puts "[FINAL]:: Write buffer to disk"
  puts "[FINAL]:: BASE DIR: #{$base}"
  begin
   puts "[FINAL]:: badchar list"+(if $verb; ": #{$data[:badstart].length}"; else ""; end) if $diag
   IO.write(File.join($base,"badstart.txt"), $data[:badstart].join("\n"), mode: 'a') if $data[:badstart].length > 0
  rescue => someerror
   puts "[FINAL]:: Failed to flush badstart"+(if $verb; ": #{someerror}"; else ""; end)
  end
  begin
   puts "[FINAL]:: tabbed list"+(if $verb; ": #{$data[:tabbed].length}"; else ""; end) if $diag
   IO.write(File.join($base,"tabbed.txt"), $data[:tabbed].join("\n"), mode: 'a') if $data[:tabbed].length > 0
  rescue => someerror
   puts "[FINAL]:: Failed to flush tabbed"+(if $verb; ": #{someerror}"; else ""; end)
  end
  begin
   puts "[FINAL]:: quoted list"+(if $verb; ": #{$data[:quoted].length}"; else ""; end) if $diag
   IO.write(File.join($base,"quoted.txt"), $data[:quoted].join("\n"), mode: 'a') if $data[:quoted].length > 0
  rescue => someerror
   puts "[FINAL]:: Failed to flush quoted"+(if $verb; ": #{someerror}"; else ""; end)
  end
  begin
   puts "[FINAL]:: semi list"+(if $verb; ": #{$data[:semi].length}"; else ""; end) if $diag
   IO.write(File.join($base,"semi.txt"), $data[:semi].join("\n"), mode: 'a') if $data[:semi].length > 0
  rescue => someerror
   puts "[FINAL]:: Failed to flush semicolon"+(if $verb; ": #{someerror}"; else ""; end)
  end
  begin
   puts "[FINAL]:: colon list"+(if $verb; ": #{$data[:colon].length}"; else ""; end) if $diag
   IO.write(File.join($base,"colon.txt"), $data[:colon].join("\n"), mode: 'a') if $data[:colon].length > 0
  rescue => someerror
   puts "[FINAL]:: Failed to flush colon"+(if $verb; ": #{someerror}"; else ""; end)
  end
  begin
   puts "[FINAL]:: pipe list"+(if $verb; ": #{$data[:pipe].length}"; else ""; end) if $diag
   IO.write(File.join($base,"pipe.txt"), $data[:pipe].join("\n"), mode: 'a') if $data[:pipe].length > 0
  rescue => someerror
   puts "[FINAL]:: Failed to flush pipe"+(if $verb; ": #{someerror}"; else ""; end)
  end
  begin
   puts "[FINAL]:: email list"+(if $verb; ": #{$data[:email].length}"; else ""; end) if $diag
   IO.write(File.join($base,"email.txt"), $data[:email].join("\n"), mode: 'a') if $data[:email].length > 0
  rescue => someerror
   puts "[FINAL]:: Failed to flush email"+(if $verb; ": #{someerror}"; else ""; end)
  end
  begin  
   puts "[FINAL]:: unknown list"+(if $verb; ": #{$data[:unknown].length}"; else ""; end) if $diag
   IO.write(File.join($base,"unknown.txt"), $data[:unknown].join("\n"), mode: 'a') if $data[:unknown].length > 0
  rescue => someerror
   puts "[FINAL]:: Failed to flush unknown"+(if $verb; ": #{someerror}"; else ""; end)
  end
  puts "[FINAL]:: Creating unqiued Cleaned list"
  puts "[FINAL]:: Before Uniqued list"+(if $verb; ": #{$data[:cleaned].length}"; else ""; end) if $diag
  udump = $data[:cleaned].uniq
  puts "[FINAL]:: After Uniqued list"+(if $verb; ": #{$data[:cleaned].length}"; else ""; end) if $diag
  puts "[FINAL]:: Creating sorted Cleaned list"
  sdump = udump.sort
  puts "[FINAL]:: Exporting Cleaned list"
  IO.write(File.join($base,"unique_sorted_cleaned.txt"), sdump.join("\n"), mode: 'a')
  puts "[FINAL]:: Exiting" if $diag
 rescue => someerror
  puts "[FINAL]:: Failed to flush buffers"+(if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
################################# [MAIN LOGIC] ################################
puts banner.join("\n")
userargs  # Get user arguments from CLI
initial
mainfun
puts "[INITIALIZER]:: Application terminating"
exit
