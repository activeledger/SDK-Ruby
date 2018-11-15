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

end
