require 'io/console'

class PreferenceUtils

  $url = "http://testnet-uk.activeledger.io:5260"

  def setConnection(protocol, url ,port)
    $url =  "#{protocol}://#{url}:#{port}"
  end

  def getConnection
    return $url
  end

  def convertJSONToString(json)
    return json.to_json
  end

  def writeKeyInFile(filename,key)
    Dir.chdir(File.dirname(__FILE__))

    aFile = File.new(filename, "w+")

    if aFile
      aFile.syswrite(key)
    else
      puts "Unable to open file!"
    end

    aFile.close
  end

end
