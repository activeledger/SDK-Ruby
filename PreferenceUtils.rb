require 'io/console'
require 'json'


class PreferenceUtils

  $url = "http://testnet-uk.activeledger.io:5260"

  # setting up connection for http request
  # requires (protocol, url and port) as an input parameters and convert them into url
  def setConnection(protocol, url ,port)
    $url =  "#{protocol}://#{url}:#{port}"
  end

  def getConnection
    return $url
  end

  def convertJSONToString(json)
    return json.to_json
  end

  # function takes filename and key as an input, writes the key into the file and saves the file to current directory
  def writeKeyInFile(filename,key)
    
    # change the directory to the root of the project
    Dir.chdir(File.dirname(__FILE__))

    # creates a new file with writing privilages
    aFile = File.new(filename, "w+")

    if aFile
      aFile.syswrite(key)
    else
      puts "Unable to open file!"
    end

    # closes the file stream
    aFile.close
  end

end
