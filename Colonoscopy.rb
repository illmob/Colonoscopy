# [DEVELOPER] #################################################################
#
# illmob, cause you didn't even try to make it
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
require 'zlib'          # ensure module is included with the script
require 'tar/reader'    # ensure module is included with the script
require 'digest'        # ensure module is included with the script
require 'ipaddr'        # ensure module is included with the script
require 'securerandom'  # ensure module is included with the script
require 'optparse'      # ensure module is included with the script
require 'ostruct'       # ensure module is included with the script
require 'iconv' unless String.method_defined?(:encode)  # ensure module is included with the script
#[userargs] ##############################] userargs [###########################################################
def userargs
 #
 # Portion to interact with user at commandline. Processes users arguments and aligns them within an options hash
 # These options are globally avalilable, and are not mutable. The can be overwritten so be sure to save the contents
 # rather than attempting to read directly from the has itself.
 #
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
   opt.on('-s','--sleep{=TIME}','Adds pause to decrease STDOUT flooding, performance hit increases') { |o|
    $options[:sleep] = o }  # adds additional debugging information to STDOUT, greater performance hit
  end.parse!  # Stop parsing options from user @ cli
 rescue => someerror  # catch error to var
  puts "[ERROR]:: OptionsParser fault: #{someerror}"
 end  # Catch/Rescue block end
end
# [banvars] ######################################################################
# Banner code needed to compelte the production of the applications graphic 
#
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
# Append lines to an array and proceed with stacking as needed to produce output when called.
#
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
#[initial] ##############################] initial [###########################################################
def initial
 #
 # Initial function to handle the assignment of user supplied arguments with application variabled
 #
 puts "[INITIALIZER]:: Application initialized"
 $directory_name = "evidence"
 puts "[INITIAL]:: Entering"+(sleep $pause; if $verb; "[INITIAL]:: Default DIR name: #{$directory_name}"; end) if $diag
 begin
  $inilist    = {:badstart => [],:quoted => [],:semi => [],:colon => [], 
                :pipe => [],:nosplit => [],:email => [],:unknown => [], 
                :tabbed => [],:cleaned => [],:upwd => [],:badconvert => [],
                :weburl => []}  # Create the default hash to be used in the application
  $speclist   = ["!", '"', "#", "$","%", "&", "'", "(", ")", "*",
                "+", ",","-", ".", "/", ":", ";", "<", "=", ">","?", "\,", "\\"]  # Create the default Special char list
  $skipfiles  = [".",".."]  # file locations to ignore
  $splitchar  = [":",";","|","\t"]  # characters known to split on
  $nillist    = ["0", "0.0", "", nil]
  $web        = ["http","https"]
  $dumpall    = false
  begin
   if $options[:debug]; $diag = true; puts "[OPTIONS]:: OptionsParser: PASSED"
   else; $diag = false 
   end  # Accept user argument for debugging
   if $options[:verbose]; $verb = true;  # Accept user argument for debugging in verbose mode
    puts "[OPTIONS]:: Debug: #{$diag}"; puts "[OPTIONS]:: Verbose: #{$verb}"
    puts "[OPTIONS]:: Explode: #{$options[:explode]}" if $options[:explode].to_s != ""
    puts "[OPTIONS]:: Input: #{$options[:input].to_s}" if $options[:input].to_s != ""
    puts "[OPTIONS]:: Folder: #{$options[:folder].to_s}" if $options[:folder].to_s != ""
    puts "[OPTIONS]:: Type: #{$options[:type].to_s}" if $options[:type].to_s != "" 
   else; $verb = false;
   end
   $pause = Float("0.0") 
   if $diag || $verb
    if ! $nillist.include? $options[:sleep]
     begin
      if $options[:sleep].split(".").length == 2
       begin
        pp $options[:sleep].split(".")
        $pause = Float($options[:sleep]) 
       rescue =>  someerror
        puts "[ERROR]:: Sleep options failed integer testing"+(if $verb; ": #{someerror}"; else ""; end) if $diag
        $pause = Float("0.0")
       end
      else
       begin
        set1 = $options[:sleep].to_i
        $pause = set1
       rescue =>  someerror
        puts "[ERROR]:: Sleep options failed integer testing"+(if $verb; ": #{someerror}"; else ""; end) if $diag
       end
      end
      puts "[OPTIONS]:: Type: #{$options[:type].to_s}" if $options[:type].to_s != ""
     rescue =>  someerror
      puts "[ERROR]:: Sleep options failed integer testing, using default"+(if $verb; ": #{someerror}"; else ""; end) if $diag
      $pause = 0
     end
    end
   end
   # Adds sleep to the output for easieir human consumption
  rescue => someerror  # catch error to va
   puts "[ERROR]:: Debugger/Verbose failed: #{someerror}"; exit
  end  # Catch/Rescue block end
  puts "[INITIAL]:: Initial debugging options set" if $diag
  puts "[INITIAL]:: Default HASH and Special Char list created" if $diag
  $compdata = ""  # Set global var
  $counter = 0  #Set counter to 0
  $wsize = 500000  # Set write size check to half million lines
  $filesin = []  # Set default list of files to be injested
  if $options[:folder].to_s != ""; $directory_name = $options[:folder]; else; $directory_name = projname($options[:input].to_s); end  # Set default evidence directory
  if $diag && $verb 
   puts "[INITIAL]:: inilist length: #{$inilist.length}"
   puts "[INITIAL]:: speclist length: #{$speclist.length}"
   puts "[INITIAL]:: splitchar length: #{$splitchar.length}"
   puts "[INITIAL]:: skipfiles length: #{$skipfiles.length}"
   puts "[INITIAL]:: Default compdata #{$compdata}"
   puts "[INITIAL]:: Default counter #{$counter}"
   puts "[INITIAL]:: Default wsize #{$wsize}"
   puts "[INITIAL]:: Default filesin #{$filesin}"
   puts "[INITIAL]:: Default options[:folder] #{$options[:folder]}"
   puts "[INITIAL]:: Creating evidence directory"+(sleep $pause; ": #{$directory_name}")
  end
  Dir.mkdir($directory_name) unless Dir.exists?($directory_name) # Create DIR if it does not exists
  puts "[INITIAL]:: Exiting" if $diag
rescue => someerror
  puts "[INITIAL]:: FATAL ERROR:: initial module"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
#[mainfun] ##############################] mainfun [###########################################################
def mainfun
 begin
  puts "[MAINFUN]:: Entering\n[MAINFUN]:: Setting application variables for filenames" if $diag
  ingestion  # Gather files to be processes from ingestion function
  puts "[MAINFUN]:: Examining files"+(sleep $pause; if $verb; ": #{$filesin}"; else ""; end) if $diag
  $filesin.each { | finfile |
   puts "[MAINFUN]:: Interacting with file"+(sleep $pause; if $verb; ": #{$finfile}"; else ""; end) if $diag
   procfiles(finfile)  # Process files to generate additional global vars
   if finfile.split(".")[-1].to_s.downcase == "txt"
    puts "[MAINFUN]:: Input file is TXT" if $diag
    inoutput(finfile)  # If file is of type TXT, process singular files contents
   end
   if finfile.split(".")[-1].to_s.downcase == "gz"
    puts "[MAINFUN]:: Input file is GZ"+(sleep $pause; if $verb; ": #{$finfile}"; else ""; end) if $diag
    tarpit(finfile)  # If file is of type GZ, inflate and process singular files contents
   end
   bufferflush  # Proceed to flush any contents that did not hit write counter limits
  }
  puts "[MAINFUN]:: Exiting" if $diag
 rescue  => someerror
  puts "[MAINFUN]:: FATAL ERROR:: mainfun module"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
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
   puts "[CONSUME]:: Initial input location used"+(sleep $pause; if $verb; ": #{$options[:input]}"; else ""; end) if $diag
   begin
    puts "[CONSUME]:: Searching directory for #{$options[:type].to_s.upcase} files:" if $diag
    foname = $options[:input]
    puts "[CONSUME]:: User options given as input"+(sleep $pause; if $verb; ": #{foname}"; else ""; end) if $diag
    Dir.entries(foname).each { | fin | 
     if $skipfiles.include? fin.to_s
      puts "[CONSUME]:: Skipped a file from being procesed"+(sleep $pause; if $verb; ": #{fin.to_s}"; else ""; end) if $diag
      next
     end
     if fin.split(".")[-1].to_s.downcase == $options[:type].to_s.downcase
      puts "[CONSUME]:: A file is being appended"+(sleep $pause; if $verb; ": #{fin.to_s}"; else ""; end) if $diag
      $filesin.append(fin.to_s)
      (if $verb; puts "[CONSUME]:: filesin: #{$filesin}"; else ""; end) if $diag
     end
    }  # If user input was of a directory, include all files @ set type
    puts "[CONSUME]:: All files being processed"+(sleep $pause; if $verb; ": #{$filesin}"; else ""; end) if $diag
   rescue => someerror
    puts "[CONSUME]:: FATAL ERROR:: ingestion module"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag;
   end
   (if $verb; puts "[CONSUME]:: Input was a directory"; end) if $diag
  end
  (if $verb; puts "[CONSUME]:: Testing if input is a file"; end) if $diag
  if File.file? $options[:input].to_s
   # If user input was of a file. include singlular file
   $filesin.append($options[:input].to_s)
   puts "[CONSUME]:: Single"+(sleep $pause; if $verb; ": #{$options[:type].to_s.upcase}"; else ""; end)+" file being processed"+(if $verb; ": #{$options[:input].to_s}"; else ""; end)
   puts "[CONSUME]:: Input was a file"+(sleep $pause; if $verb; ": #{$options[:input].to_s}"; end) if $diag
  end
  return # Return the generated list of files for additional processing
 rescue => someerror
  puts "[CONSUME]:: Please enter a file.txt or directory containing .gz files"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
 puts "[CONSUME]:: Exiting" if $diag
end
# [projname] ##################################################################
def projname(project)
 begin
  puts "[PROJECT]:: Entering"+(sleep $pause; if $verb; ": #{project}"; else ""; end) if $diag
  if project.split(".").length >= 2
   prepro = project.split(".")[-2]  # Split filename and store results
  else
    prepro = project
  end
  puts "[PROJECT]:: Project name modified"+(sleep $pause; if $verb; ": #{prepro}"; else ""; end) if $diag
  prepro = prepro.split("/")[-1] if project.split("/").length >= 2  # Split directory and store results
  (if $verb; puts "[PROJECT]:: Project name Split 1 #{prepro}"; else ""; end) if $diag
  prepro = prepro.split("\\")[-1] if project.split("\\").length >= 2  # Split directory and store results
  (if $verb; puts "[PROJECT]:: Project name Split 2 #{prepro}"; else ""; end) if $diag
  projectname = prepro
  puts "[PROJECT]:: Project final name set"+(sleep $pause; if $verb; ": #{projectname}"; else ""; end) if $diag
 rescue => someerror
  puts "[PROJECT]:: Failed to produce project name"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag  # generate a new project name
  projectname = SecureRandom.alphanumeric
  puts "[PROJECT]:: Generated project name"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag  # generate a new project name
 end
 puts "[PROJECT]:: Exiting" if $diag
 return projectname  # Return the project name for additional processing
end
# [procfiles] ##################################################################
def procfiles(infile)
 begin
  puts "[PROCESS]:: Entering"+(sleep $pause; if $verb; ": #{infile}"; else ""; end) if $diag
  project = projname(infile)  # Set porject name to generate file structure
  puts "[PROCESS]:: Project passed from projname: #{project}" if $diag
  (if $verb; puts "[PROCESS]:: directory_name: #{$directory_name}"; else ""; end) if $diag
  $base = File.join($directory_name, project)  # Set base DIR name to store files
  puts "[PROCESS]:: Base location set"+(sleep $pause; if $verb; ": #{$base}"; else ""; end) if $diag;
  begin
   Dir.mkdir($base) unless Dir.exists?($base)  # Create base DIR if it does not exists
   puts "[PROCESS]:: File/Folder creation: PASSED"+(sleep $pause; if $verb; ": #{$base}"; else ""; end) if $diag
  rescue => someerror
   puts "[PROCESS]:: File/Folder not created"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag
  end
 rescue => someerror
  puts "[PROCESS]:: Failed to process project directories"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit  # generate files as needed
 end
 puts "[PROCESS]:: Exiting" if $diag
end
# [inoutput] ##################################################################
def inoutput(infile)
 begin
  puts "[IOREADER]:: Entering"+(sleep $pause; if $verb; ": #{infile}"; else ""; end) if $diag
  if not $options[:input].to_s == infile.to_s; newfile = File.join($options[:input].to_s, infile)
  else; newfile = infile
  end
  $data = $inilist  # Set default has to global variable
  puts "[IOREADER]:: Datahash set to default"+(sleep $pause; if $verb; ": #{$data.length}"; else ""; end) if $diag
  IO.foreach(newfile){ | xnf | if gauntlet(xnf) == true; next; else; if $verb; puts "[IOREADER]:: skipped test case #{x}"; else ""; end; end }  # Process each line of file
 rescue => someerror
  puts "[IOREADER]:: Failed to parse file"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit  # reading input file
 end
 puts "[IOREADER]:: Exiting" if $diag
end
# [tarpit] ####################################################################
def tarpit(infile)
 begin
  puts "[TARPIT]:: Entering"+(sleep $pause; if $verb; ": #{infile}"; else ""; end) if $diag
  Tar::Reader.new( Zlib::GzipReader.open(infile)).each { |fzile|
   sticky = []  # default content list may change inn future
   (if $verb; puts "[TARPIT]:: Entry list set :#{sticky.length}"; else "0"; end) if $diag
   $data = $inilist  # Set default has to global variable
   (if $verb; puts "[TARPIT]:: Default datahash set: #{$data.length}"; else "0"; end) if $diag
   puts "[TARPIT]:: #{fzile.header}" if $diag
   if fzile.header.size.to_i == 0; next;  end  # Skip entry if size is 0
   compfile = fzile.header.name
   puts "[TARPIT]:: Compressed file: #{compfile}"
   compfilelen = fzile.header.size
   puts "[TARPIT]:: Commiting #{compfilelen} bytes to memory, please wait" if $diag
   # Read contents of commpressed file and append to list
   begin; fzile.read.each_line {|xfzile| sticky.append(xfzile)}
   rescue; puts "[TARPIT]:: Finished processing #{compfile}" if $diag;
   end
   puts "[TARPIT]:: Inflated data length: #{sticky.length}" if $diag
   puts "[TARPIT]:: Proceeding to Gauntlet" if $diag;
   sticky.each { | xsticky | if gauntlet(xsticky) == true; next; end }  # Process each line of file
   puts "[TARPIT]:: Gauntlet  processing finished" if $diag
  }
 rescue => someerror; puts "[TARPIT]:: Failed to parse GZ file"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit  # reading gz contents file
 end
 puts "[TARPIT]:: Exiting" if $diag
end
# [gauntlet] ##################################################################
def gauntlet(gstring)
 begin
  puts "[GUANTLET]:: Entering"+(sleep $pause; if $verb; ": #{gstring}"; else ""; end) if $diag
  $counter +=1  # Increment counter by 1
  (if $verb; puts "[GUANTLET]:: Counter incremented #{$counter}"; else "0"; end) if $diag
  estring = encoded(gstring)  # Attempt to encode string as needed in forgine dumps
  (if $verb; puts "[GUANTLET]:: Encoded entry: #{estring} of #{gstring}"; else ""; end) if $diag
  if checkfirst(estring) == true; (if $verb; puts "[GUANTLET]:: Checkfirst PASSED: #{estring}"; end) if $diag; return true; 
  else; puts "[ERROR]:: Guantlet failed unknown: #{gstring}" if $diag; end  # Process entry through module if failed previous, final attempt EOF
  puts "[GUANTLET]:: Exiting" if $diag
rescue => someerror; puts "[GUANTLET]:: Failed to run the guantlet"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit  # reading gz contents file
 end 
 return true  # Even if results are unknown return true
end
 # [checkfirst] ################################################################
def checkfirst(checkstring)
 begin
  if checkstring.length > 100
   unknown(checkstring)
   puts "[VALIDATOR]:: Exiting"+(sleep $pause; if $verb; ": #{checkstring}"; else ""; end) if $diag
   return true
  end
  puts "[VALIDATOR]:: Entering"+(sleep $pause; if $verb; " consuming: #{checkstring}"; else ""; end) if $diag
  if $speclist.include? checkstring[0].to_s[0]  # Check if the leading character in entry is a Special Character
   specchat = checkstring[0].to_s[0].to_s
   puts "[VALIDATOR]:: Found lead character in speclist"+(sleep $pause; if $verb; ": #{checkstring}"; else ""; end) if $diag
   #  Check if first location after split is a valid email address or not
   begin
    if not validemail(if checkstring.split(":").length >= 2; checkstring.split(":")[0].delete! specchat; end) ||
     begin
      if not validemail(if checkstring.split(";").length >= 2; checkstring.split(";")[0].delete! specchat; end) ||
       begin
        if not validemail(if checkstring.split("|").length >= 2; checkstring.split("|")[0].delete! specchat; end) ||
         begin
          if not validemail(if checkstring.split("\t").length >= 2; checkstring.split("\\t")[0].delete! specchat; end)
           puts "[VALIDATOR]:: No valid email in the first set"+(sleep $pause; if $verb; ": #{checkstring}"; else ""; end) if $diag
           begin
            if quoted(checkstring) == false # Process entry to validate if the entry is quoted or "?" and if not upwdsplit
             begin
              if questions(checkstring) == false
               unknown(checkstring)
               puts "[VALIDATOR]:: Exiting"+(sleep $pause; if $verb; ": #{checkstring}"; else ""; end) if $diag
               return true
              end
             rescue => someerror; puts "[VALIDATOR]:: 1Exiting Failed to parse contents #{someerror}"; exit
             end  # Future use case, if they arrise
            end
           rescue => someerror; puts "[VALIDATOR]:: 2Exiting Failed to parse contents #{someerror}"; exit
           end  # Future use case, if they arrise
          end
         rescue => someerror; puts "[VALIDATOR]:: 3Exiting Failed to parse contents #{someerror}"; exit
         end  # Future use case, if they arrise
 	      end
       rescue => someerror; puts "[VALIDATOR]:: 4Exiting Failed to parse contents #{someerror}"; exit
       end  # Future use case, if they arrise
      end
     rescue => someerror; puts "[VALIDATOR]:: 5Exiting Failed to parse contents #{someerror}"; exit
     end  # Future use case, if they arrise
    end
   rescue => someerror; puts "[VALIDATOR]:: 6Exiting Failed to parse contents #{someerror}"; exit
   end  # Future use case, if they arrise
  else
   puts "[VALIDATOR]:: No leading Special Characters found, sending to decider"+(sleep $pause; if $verb; ": #{checkstring}"; else ""; end) if $diag
   puts "[VALIDATOR]:: Exiting"+(sleep $pause; if $verb; ": #{checkstring}"; else ""; end) if $diag
   if decider(checkstring) == true;  puts "[VALIDATOR]:: Exiting" if $diag
    return true; end
  end
 rescue => someerror; puts "[VALIDATOR]:: Exiting Failed to parse contents #{someerror}"; exit
 end
 puts "[VALIDATOR]:: Exiting" if $diag
 return true
end
# [questions] ##################################################################
def decider(decisions)
 puts "[DECIDER]:: Entering"+(sleep $pause; if $verb; ": #{decisions}"; else ""; end) if $diag
 begin
  trigger = false # Set to 0 for initial process
  (if $verb; puts "[DECIDER]:: Default trigger: #{trigger}"; else ""; end) if $diag
  while trigger == false  # Keep running until true
   begin
    (if $verb; puts "[DECIDER]:: Trigger status: #{trigger}"; else ""; end) if $diag
    puts "[DECIDER]:: Started Processing entry for catagorization" if $diag
    # Attempt to identify the structure of the entry through indepth validation routines
    $splitchar.each { | schar |
     if decisions.split(schar).length >= 2; if lenrun(schar,decisions) == true; trigger = true; puts "[DECIDER]:: split at #{schar}" if $diag;  puts "[DECIDER]:: Exiting" if $diag; return true; end; end
    }
    puts "[DECIDER]:: Finished Processing entry for catagorization" if $diag
   rescue => someerror
    puts "[DECIDER]:: Failed at splitting, return true"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag
    trigger = true  # Return true even in failure to stop the loop
    (if $verb; puts "[DECIDER]:: Default trigger: #{trigger}"; else ""; end) if $diag
   end
   puts "[DECIDER]:: This should never happen, return true"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag
   trigger = true  # Return true even in failure to stop the loop
   (if $verb; puts "[DECIDER]:: Default trigger: #{trigger}"; else ""; end) if $diag
  end
  return true
 rescue => someerror; puts "[DECIDER]:: Failed to make decision"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; end
 puts "[DECIDER]:: Exiting" if $diag
end
# [questions] ##################################################################
def questions(queststring)
 begin
  puts "[QUESTION]:: Entering"+(sleep $pause; if $verb; ": #{queststring}"; else ""; end) if $diag
  if queststring[0].to_s[0] == '?'  # Check if the leading character is a questionmark
   puts "[QUESTION]:: First character is a questionmark"+(sleep $pause; if $verb; ": #{queststring}"; else ""; end) if $diag
   queststring = queststring.strip()  # Attempt to strip any newline character from end of entry
   puts "[QUESTION]:: Ensure input has no newline character(s)"+(sleep $pause; if $verb; ": #{queststring}"; else ""; end) if $diag
   # Start spliting the entry from different known delimeters and attempt to vlaidate the string with lenrun
   if (
    $splitchar.each { |schar |
     if (
      puts "[QUESTION]:: Iterating split character"+(sleep $pause; if $verb; ": #{schar}" ; else ""; end) if $diag
      if validemail(queststring.split(schar)[1])
       email = queststring.split(schar)[1].strip(" ")
       puts "[QUESTION]:: Set email from first element"+(sleep $pause; if $verb; ": #{email}" ; else ""; end) if $diag
       remainder =  queststring.split(schar)[2..-1].join(schar)
       puts "[QUESTION]:: Set remainder of string"+(sleep $pause; if $verb; ": #{remainder}" ; else ""; end) if $diag
       newmail = email+schar+remainder
       puts "[QUESTION]:: Set new email"+(sleep $pause; if $verb; ": #{newmail}" ; else ""; end) if $diag
       puts "[QUESTION]:: Exiting" if $diag
       lenrun(schar,newmail)
      end
      ) == true
      puts "[QUESTION]:: Valid entry found"+(sleep $pause; if $verb; ": #{newmail}" ; else ""; end) if $diag
      puts "[QUESTION]:: Exiting" if $diag
      return true
     end
    }
   ) != true
    puts "[QUESTION]:: Appending to badsplit list"+(sleep $pause; if $verb; ": #{x}"; else ""; end) if $diag
    puts "[QUESTION]:: Exiting" if $diag
    badsplit(queststring)
    return true
   end
  end
 rescue => someerror;puts "[QUESTION]:: Failed to make process input"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag
 end
 puts "[QUESTION]:: Exiting" if $diag
end
 # [encoded] ##################################################################
def encoded(plainstring)
 begin
  puts "[ENCODEX]:: Entering"+(sleep $pause; if $verb; ": #{plainstring}"; else ""; end) if $diag
  begin
   # Attempt to remove newline characters from entry and return results
   encodedstring = plainstring.strip()  # Removes newline character with standard ruby strip
   puts "[ENCODEX]:: Generic Strip newline from #{encodedstring}" if $diag
  rescue => someerror
   puts "[ENCODEX]:: Failed to strip newline from from string"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag
   begin
    encodedstring = convert8string(plainstring).strip()  # Standard converstion for Standard English
    puts "[ENCODEX]:: Encode string in utf8 #{encodedstring}" if $diag
   rescue => someerror
     puts "[ENCODEX]:: Failed encode string in utf8"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag
    begin
     encodedstring =  conver16string(plainstring).strip()  # Can happen with Arabic/Chines chars
     puts "[ENCODEX]:: Encode string in utf16 #{encodedstring}" if $diag
    rescue => someerror
     puts "[ENCODEX]:: Failed encode string in utf16"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag
     begin
      encodedstring = utf821628(plainstring).strip()  # Only happens when difficult to encode entries are present (China)
      puts "[ENCODEX]:: Encode string UTC8=>16=>8 #{encodedstring}" if $diag
     rescue => someerror
      puts "[ENCODEX]:: Failed encode string in UTF8=>16=>8"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag
     end
     puts "[ENCODEX]:: Exiting"+(sleep $pause; if $verb; ": #{encodedstring}"; else ""; end) if $diag
     return encodedstring
    end
    puts "[ENCODEX]:: Exiting"+(sleep $pause; if $verb; ": #{encodedstring}"; else ""; end) if $diag
    return encodedstring  
   end
   puts "[ENCODEX]:: Exiting"+(sleep $pause; if $verb; ": #{encodedstring}"; else ""; end) if $diag
   return encodedstring
  end
  puts "[ENCODEX]:: Exiting"+(sleep $pause; if $verb; ": #{encodedstring}"; else ""; end) if $diag
  return encodedstring
 rescue => someerror; puts "[ENCODEX]:: Failed to encodes input"+(sleep $pause; if $verb; ": #{encodedstring}"; else ""; end) if $diag
 end
 puts "[ENCODEX]:: Exiting"+(sleep $pause; if $verb; ": #{plainstring}"; else ""; end) if $diag
end
# [lenrun] ####################################################################
def lenrun(char, lenstring)
 begin
  $newx = ""
  puts "[LENRUN]:: Entering"+(sleep $pause; if $verb; ": #{char}, #{lenstring}"; else ""; end) if $diag
  if lenstring.split(char).length >= 2  # If split results in a length of 2 or more
   puts "[LENRUN]:: Passed length requirement"+(sleep $pause; if $verb; ":#{lenstring.split(char).length}"; else ""; end) if $diag
   if lenstring.split(char).length == 2  # If split is exact length, process further and validate entries
    puts "[LENRUN]:: Entry is exact"+(sleep $pause; if $verb; ":#{lenstring.split(char).length}"; else ""; end) if $diag
    set1 = lenstring.split(char)[0]; set2 = lenstring.split(char)[1]  # split and set positions based on length, and validate
    if validemail(set1); 
     $newx = set1+char+set2; 
     puts "[LENRUN]:: Valid set1 #{set1}" if $diag;
    elsif validemail(set2); 
     $newx = set2+char+set1; 
     puts "[LENRUN]:: Valid set2 #{set2}" if $diag;
    else; 
     puts "[LENRUN::USPWD]:: NO VALID EMAILS FOUND: #{lenstring} #{$counter}" if $diag; 
     upwdsplit(lenstring); 
     return true; 
    end;
   end
  end
  if lenstring.split(char).length >= 3  # If split results in a length of 3 or more
   puts "[LENRUN]:: Entry is 3 or greater "+(sleep $pause; if $verb; ":#{lenstring.split(char).length}"; else ""; end) if $diag
   set1 = lenstring.split(char)[0]
   set2 = lenstring.split(char)[1]
   if $web.include? set1  # check if set1 has signature of URL
    if set2.split("/").length > 2  # check if set2 has signature of URL
     if websplit(lenstring) == true # append to weburl list
      return true  # return true to continue applications logic per entry
     end
    end
   end
   set3 = lenstring.split(char)[2]  # split and set positions based on length, and validate
   if lenstring.split(char).length > 3; 
    set4 = lenstring.split(char)[3]
   else;
     set4 = lenstring.split(char)[3..1].join(char)
    end
   end
   while $newx == ""
    if validemail(set1);    $newx = set1+char+set2+char+set3+set4; puts "[LENRUN]:: Valid set1 #{set1}" if $diag
    elsif validemail(set2); $newx = set2+char+set1+char+set3+set4; puts "[LENRUN]:: Valid set2 #{set2}" if $diag
    elsif validemail(set3); $newx = set3+char+set1+char+set2+set4; puts "[LENRUN]:: Valid set3 #{set3}" if $diag
    elsif validemail(set4); $newx = set4+char+set1+char+set2+char+set3; puts "[LENRUN]:: Valid set4 #{set4}" if $diag
    else
     unknwon(lenstring); puts "[LENRUN]:: No valid email found, appended to unknown #{set3}" if $diag; return true
   end
   puts "[LENRUN]:: Split entry in parts"+(sleep $pause; if $verb; ": #{set1}, #{set2}, #{set3}, #{set4}"; else ""; end) if $diag
  end
  puts "[LENRUN]:: Combined new entry"+(sleep $pause; if $verb; ": #{$newx}"; else ""; end) if $diag 
  if $newx.to_s != ""  # as long as newx is not blank
   $data[:cleaned].append($newx)  # Append newx to cleaned list of known good sets
   puts "[LENRUN]:: Append newx to clean list"+(sleep $pause; if $verb; ": #{$newx}"; else ""; end) if $diag
   # Attempt to have entry parsed into respective entry list
   if char.to_s == "\t"; if tabsplit(lenstring) == true;   puts "[LENRUN]:: TABBED - #{$newx} #{$counter}" if $diag;  puts "[LENRUN]:: Exiting" if $diag; return true; end; end
   if char.to_s == ":";  if colonsplit(lenstring) == true; puts  "[LENRUN]:: COLON - #{$newx} #{$counter}" if $diag;  puts "[LENRUN]:: Exiting" if $diag; return true; end; end
   if char.to_s == ";";  if semisplit(lenstring) == true;  puts   "[LENRUN]:: SEMI - #{$newx} #{$counter}" if $diag;  puts "[LENRUN]:: Exiting" if $diag; return true; end; end
   if char.to_s == "|";  if pipesplit(lenstring) == true;  puts   "[LENRUN]:: PIPE - #{$newx} #{$counter}" if $diag;  puts "[LENRUN]:: Exiting" if $diag; return true; end; end
   # if entry does not quantify into its repsective list, add entry to unkwown list
  else; unknown(lenstring); puts "[LENRUN]:: NO VALID FORMATS FOUND: #{lenstring} #{$counter}" if $diag; puts "[LENRUN]:: Exiting" if $diag; return true
  end
 rescue => someerror; puts "[LENRUN]:: Failed to run length of input"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end); puts "[LENRUN]:: Exiting" if $diag; exit
 end
 puts "[LENRUN]:: Exiting" if $diag
 return
end
# [quoted] ##################################################################
def quoted(quotestring)  # Checks if entry is quoted of not
 puts "[QUOTED]:: Entering"+(sleep $pause; if $verb; ": #{quotestring}"; else ""; end) if $diag
 begin
  # If entry is quotes, run entry through respective parser
  if quotestring[0].to_s[0] == '"'; puts "[QUOTED]:: Append to Quoted list\n[QUOTED]:: Exiting" if $diag; quotesplit(quotestring); return true
	end
 rescue => someerror; puts "[QUOTED]:: Failed to identify quoted content"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end); puts "[QUOTED]:: Exiting" if $diag
 end
end
# [makehash] ##################################################################
def makehash(datain)  # Returns a MD5 hash of given dataset
 begin
  puts "[MAKEHASH]:: Entering"+(sleep $pause; if $verb; ": #{datain}"; else ""; end) if $diag
  newhash = $md5.update(datain).hexdigest
  puts "[MAKEHASH]:: New hash"+(sleep $pause; if $verb; ": #{newhash}"; else ""; end) if $diag
  $md5.reset  # Reset for any additional use after completion
  puts "[MAKEHASH]:: Exiting" if $diag
 rescue => someerror; puts "[MAKEHASH]:: Failed producing MD5 sum"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end);  puts "[MAKEHASH]:: Exiting" if $diag ; exit
 end
 return newhash
end
# [validemail] ################################################################
def validemail(email)  # Check if entry is a valid email address
 begin
  puts "[VALIDMAIL]:: Entering" +(sleep $pause; if $verb; ": #{email}"; else ""; end) if $diag
  if /.+@.+\..+/i.match(email); puts "[VALIDMAIL]:: Email validated"+(sleep $pause; if $verb; ": #{email}"; else ""; end) if $diag; puts "[VALIDMAIL]:: Exiting" if $diag; return true; else; puts "[VALIDMAIL]:: INVALID Email "+(sleep $pause; if $verb; ": #{email}"; else ""; end) if $diag; end
 rescue => someerror
  puts "[VALIDMAIL]:: Exiting" if $diag
  puts "[VALIDMAIL]:: Failed in validating email"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [valid4ip] ################################################################
def valid4ip(address)  # Check if entry is a valid ipv4 address
 begin
  puts "[VALIDIPV4]:: Entering"+(sleep $pause; if $verb; ": #{address}"; else ""; end) if $diag
  ip = IPAddr.new(address)
  if ip.ipv4?; puts "[VALIDIPV4]:: IPv4 validated"+(sleep $pause; if $verb; ": #{address}"; else ""; end) if $diag;  puts "[VALIDIPV4]:: Exiting"; return true; end
 rescue => someerror
  puts "[VALIDIPV4]:: Failed in ipv4 validation"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
  puts "[VALIDIPV4]:: Exiting" if $diag
end
end
# [valid6ip] ################################################################
def valid6ip(address)  # Check if entry is a valid ipv6 address
 begin
  puts "[VALIDIPV6]:: Entering"+(sleep $pause; if $verb; ": #{address}"; else ""; end) if $diag
  ip = IPAddr.new(address)
  if ip.ipv6?; puts "[VALIDIPV6]:: IPv6 validated"+(sleep $pause; if $verb; ": #{address}"; else ""; end) if $diag;  puts "[VALIDIPV6]:: Exiting"; return true; end
 rescue => someerror
  puts "[VALIDIPV6]:: Failed in ipv6 validation"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
  puts "[VALIDIPV6]:: Exiting" if $diag
end
end
# [convert8string] ################################################################
def convert8string(xstring)  # Convert entry into UTF8
 begin
  puts "[UTF*STR]:: Entering"+(sleep $pause; if $verb; ": #{xstring}"; else ""; end) if $diag
  if String.method_defined?(:encode)
   estring = xstring.encode!('UTF-8', :invalid => :replace, :replace => '')
   puts "[UTF*STR]:: Str UTF8 validated"+(sleep $pause; if $verb; ": #{estring}"; else ""; end) if $diag
   puts "[UTF*STR]:: Exiting" if $diag
   return estring
  else
   ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
   str2 = ic.iconv(xstring)
   puts "[UTF*STR]:: Str UTF8+IGNORE validated"+(sleep $pause; if $verb; ": #{estring}"; else ""; end) if $diag
   puts "[UTF*STR]:: Exiting" if $diag
   return estring
  end
 rescue => someerror
  puts "[UTF*STR]:: Failed in convert UFT 8 string validation"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [convert16string] ################################################################
def convert16string(xstring)  # Convert entry from UTF8 into UTF16
 begin
  puts "[UTF*STR]:: Entering"+(sleep $pause; if $verb; ": #{xstring}"; else ""; end) if $diag
  if String.method_defined?(:encode)
   estring = xstring.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
   puts "[UTF*STR]:: Str UTF16 validated"+(sleep $pause; if $verb; ": #{estring}"; else ""; end) if $diag
   puts "[UTF*STR]:: Exiting" if $diag
   return estring
  else
   ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
   estring = ic.iconv(xstring)
   puts "[UTF*STR]:: Str UTF8+IGNORE validated"+(sleep $pause; if $verb; ": #{estring}"; else ""; end) if $diag
   puts "[UTF*STR]:: Exiting" if $diag
   return estring
  end
 rescue => someerror
  puts "[UTF*STR]:: Failed in convert UTF16 string validation"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [utf821628] ################################################################
def utf821628(xstring)  # Convert entry from UTF8 into UTF16 and back into UTF8
 begin
  puts "[UTF*STR]:: Entering"+(sleep $pause; if $verb; ": #{str1}"; else ""; end) if $diag
  if String.method_defined?(:encode)
   x1string = xstring.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
   estring = x1string.encode!('UTF-8', 'UTF-16')
   puts "[UTF*STR]:: Str UTF16/8/16 validated"+(sleep $pause; if $verb; ": #{estring}"; else ""; end) if $diag
   puts "[UTF*STR]:: Exiting" if $diag
   return estring
  else
   ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
   estring = ic.iconv(xstring)
   puts "[UTF*STR]:: Str UTF16/8/16 validated"+(sleep $pause; if $verb; ": #{estring}"; else ""; end) if $diag
   puts "[UTF*STR]:: Exiting" if $diag
   return estring
  end
 rescue => someerror
  puts "[UTF*STR]:: Failed in convert 8 into 16 into string validation"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [badsplit] ##################################################################
def badsplit(xstring)  # create entry if string did not split
 begin
  puts "[BADCHARWRITER]:: Entering"+(sleep $pause; if $verb; ": #{xstring}"; else ""; end) if $diag
  if $data[:badstart].length >= $wsize || $dumpall && $data[:badstart].length.to_i >= 1;
   filename = File.join($base,"badstart.txt")
   puts "[BADCHARWRITER]:: #{filename}, #{$counter}"
   IO.write(filename,$data[:badstart].join("\n"), mode: 'a')
   if $dumpall; return; end
   $data[:badstart] = []
   $data[:badstart].append(xstring)
  else; puts "[BADCHAR]:: #{xstring}" if $diag; $data[:badstart].append(xstring)
  end
  puts "[BADCHARWRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[BADCHARWRITER]:: Failed append to badchar list"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [tabsplit] ##################################################################
def tabsplit(tabstring)  # Attempt to split entry with tab
 begin
  puts "[TAB\\tWRITER]:: Entering"+(sleep $pause; if $verb; ": #{tabstring}"; else ""; end) if $diag
  if $data[:tabbed].length >= $wsize || $dumpall && $data[:tabbed].length.to_i >= 1;
   filename = File.join($base,"tabbed.txt")
   puts "[TAB\\tWRITER]:: #{filename}, #{$counter}"
   IO.write(filename, $data[:tabbed].join("\n"), mode: 'a')
   if $dumpall; return; end
   $data[:tabbed] = []
   $data[:tabbed].append(tabstring)
  else; $data[:tabbed].append(tabstring)
  end
  puts "[TAB\\tWRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[TAB\\tWRITER]:: Failed append to write tabbed list"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [quotesplit] #################################################################
def quotesplit(quotestring)  # Add entry into quoted list
 begin
  puts "[QUOTEWRITER]:: Entering"+(sleep $pause; if $verb; ": #{quotestring}"; else ""; end) if $diag
  if $data[:quoted].length >= $wsize || $dumpall && $data[:quoted].length.to_i >= 1;
   filename = File.join($base,"quoted.txt")
   puts "[QUOTEWRITER]:: #{filename}, #{$counter}"
   IO.write(filename, $data[:quoted].join("\n"), mode: 'a')
   if $dumpall; return; end
   $data[:quoted] = []
   $data[:quoted].append(quotestring)
  else; puts "[QUOTEWRITER]:: #{quotestring}"; $data[:quoted].append(quotestring)
  end
  puts "[QUOTEWRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[QUOTEWRITER]:: Failed append to quoted list"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [pipesplit] #################################################################
def pipesplit(pipestring)  # Attempt to split entry with pipe
 begin
  puts "[PIPE|WRITER]:: Entering"+(sleep $pause; if $verb; ": #{pipestring}"; else ""; end) if $diag
  if $data[:pipe].length >= $wsize || $dumpall && $data[:pipe].length.to_i >= 1;
   filename = File.join($base,"pipe.txt")
   puts "[PIPE|WRITER]:: #{filename}, #{$counter}"
   IO.write(filename, $data[:pipe].join("\n"), mode: 'a')
   if $dumpall; return; end
   $data[:pipe] = []
   $data[:pipe].append(pipestring)
  else; $data[:pipe].append(pipestring)
  end
  puts "[PIPE|WRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[PIPE|WRITER]:: Failed append to pipe list"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [semisplit] #################################################################
def semisplit(semistring)  # Attempt to split entry with semicolon
 begin
  puts "[SEMI;WRITER]:: Entering"+(sleep $pause; if $verb; ": #{semistring}"; else ""; end) if $diag
  if $data[:semi].length >= $wsize || $dumpall && $data[:semi].length.to_i >= 1;
   filename = File.join($base,"semi.txt")
   puts "[SEMI;WRITER]:: #{filename}, #{$counter}"
   IO.write(filename, $data[:semi].join("\n"), mode: 'a')
   if $dumpall; return; end
   $data[:semi] = []
   $data[:semi].append(semistring)
  else; $data[:semi].append(semistring)
  end
  puts "[SEMI;WRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[SEMI;WRITER]:: Failed append to semicolon list"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [colonsplit] ################################################################
def colonsplit(colonstring)  # Attempt to split entry with colon
 begin
  puts "[COLO:WRITER]:: Entering"+(sleep $pause; if $verb; ": #{colonstring}"; else ""; end) if $diag
  if $data[:colon].length >= $wsize || $dumpall && $data[:colon].length.to_i >= 1;
   filename = File.join($base,"colon.txt")
   puts "[COLO:WRITER]:: #{filename}, #{$counter}"
   IO.write(filename, $data[:colon].join("\n"), mode: 'a')
   if $dumpall; return; end
   $data[:colon] = []
   $data[:colon].append(colonstring)
  else; $data[:colon].append(colonstring)
  end
  puts "[COLO:WRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[COLO:WRITER]:: Failed append to colon list"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [unknown] ###################################################################
def unknown(unknownstring)   # Add entry to unkwown list
 begin
  puts "[KNOW?WRITER]:: Entering"+(sleep $pause; if $verb; ": #{unknownstring}"; else ""; end) if $diag
  if $data[:unknown].length >= $wsize || $dumpall && $data[:unknown].length.to_i >= 1;
   filename = File.join($base,"unknown.txt")
   puts "[KNOW?WRITER]:: #{filename}, #{$counter}"
   IO.write(filename, $data[:unknown].join("\n"), mode: 'a')
   if $dumpall; return; end
   $data[:unknown] = []
   $data[:unknown].append(unknownstring)
  else; $data[:unknown].append(unknownstring)
  end
  puts "[KNOW?WRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[KNOW?WRITER]:: Failed append to unknown list"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [upwdsplit] #################################################################
def upwdsplit(upstring)  # Add entry into username and password list
 begin
  puts "[UPWDWRITER]:: Entering"+(sleep $pause; if $verb; ": #{upstring}"; else ""; end) if $diag
  if $data[:upwd].length.to_i >= $wsize || $dumpall && $data[:upwd].length.to_i >= 1;
   filename = File.join($base,"userpass.txt")
   puts "[UPWDWRITER]:: #{filename}, #{$counter}"
   IO.write(filename, $data[:upwd].join("\n"), mode: 'a'); 
   if $dumpall; return; end
   $data[:upwd] = []; 
   $data[:upwd].append(upstring)
  else; $data[:upwd].append(upstring)
  end
  puts "[UPWDWRITER]:: Exiting" if $diag
  return true
 rescue => someerror
  puts "[UPWDWRITER]:: Failed append to userpass list"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
# [websplit] #################################################################
def websplit(webstring)  # Add entry into web url list
  begin
   puts "[WEBWRITER]:: Entering"+(sleep $pause; if $verb; ": #{webstring}"; else ""; end) if $diag
   if $data[:weburl].length.to_i >= $wsize || $dumpall && $data[:weburl].length.to_i >= 1;
    filename = File.join($base,"weburl.txt")
    puts "[WEBWRITER]:: #{filename}, #{$counter}"
    IO.write(filename, $data[:weburl].join("\n"), mode: 'a');
    if $dumpall; return; end
    $data[:weburl] = [];
    $data[:weburl].append(webstring)
   else
    $data[:upwd].append(webstring)
   end
   puts "[WEBWRITER]:: Exiting" if $diag
   return true
  rescue => someerror
   puts "[WEBWRITER]:: Failed append to web list"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
  end
 end
# [bufferflush] ###############################################################
def bufferflush  # Write any left over contents within the $data hash
 $dumpall = true
 begin
  puts "[FINAL]:: Entering" if $diag
  puts "[FINAL]:: Write buffer to disk"
  puts "[FINAL]:: BASE DIR: #{$base}"
  begin
   puts "[FINAL]:: badchar list"+(sleep $pause; if $verb; if $data[:badstart].length >= 1; ": #{$data[:badstart].length}"; else ""; end; end) if $diag; badsplit("")
   puts "[FINAL]:: tabbed list"+(sleep $pause; if $verb; if $data[:tabbed].length >= 1; ": #{$data[:tabbed].length}"; else ""; end; end) if $diag; tabsplit("")
   puts "[FINAL]:: quoted list"+(sleep $pause; if $verb; if $data[:quoted].length >= 1; ": #{$data[:quoted].length}"; else ""; end; end) if $diag; quotesplit("")
   puts "[FINAL]:: semi list"+(sleep $pause; if $verb; if $data[:semi].length >= 1; ": #{$data[:semi].length}"; else ""; end; end) if $diag; semisplit("")
   puts "[FINAL]:: colon list"+(sleep $pause; if $verb; if $data[:colon].length >= 1; ": #{$data[:colon].length}"; else ""; end; end) if $diag; colonsplit("")
   puts "[FINAL]:: pipe list"+(sleep $pause; if $verb; if $data[:pipe].length >= 1; ": #{$data[:pipe].length}"; else ""; end; end) if $diag; pipesplit("")
   puts "[FINAL]:: email list"+(sleep $pause; if $verb; if $data[:upwd].length >= 1; ": #{$data[:upwd].length}"; else "";end; end) if $diag; upwdsplit("")
   puts "[FINAL]:: web list"+(sleep $pause; if $verb; if $data[:weburl].length >= 1; ": #{$data[:weburl].length}"; else ""; end; end) if $diag; websplit("")
   puts "[FINAL]:: unknown list"+(sleep $pause; if $verb; if $data[:unknown].length >= 1; ": #{$data[:unknown].length}"; else ""; end; end) if $diag; unknwon("")
  rescue => someerror; puts "[FINAL]:: Failed to flush unknown"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end)
  end
  puts "[FINAL]:: Creating unqiued Cleaned list"
  puts "[FINAL]:: Before Uniqued list"+(sleep $pause; if $verb; ": #{$data[:cleaned].length}"; else ""; end) if $diag
  udump = $data[:cleaned].uniq
  puts "[FINAL]:: After Uniqued list"+(sleep $pause; if $verb; ": #{$data[:cleaned].length}"; else ""; end) if $diag
  puts "[FINAL]:: Creating sorted Cleaned list"
  sdump = udump.sort
  puts "[FINAL]:: Exporting Cleaned list"
  IO.write(File.join($base,"unique_sorted_cleaned.txt"), sdump.join("\n"), mode: 'a')
  puts "[FINAL]:: Exiting" if $diag
 rescue => someerror; puts "[FINAL]:: Failed to flush buffers"+(sleep $pause; if $verb; ": #{someerror}"; else ""; end) if $diag; exit
 end
end
################################# [MAIN LOGIC] ################################
puts banner.join("\n")
userargs  # Get user arguments from CLI
initial
mainfun
puts "Total processed count: #{$counter}"
puts "[INITIALIZER]:: Application terminating"
exit
