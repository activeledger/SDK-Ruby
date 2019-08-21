=begin
  MIT License (MIT)
  Copyright (c) 2018
 
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
 
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
 
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
=end
require 'io/console'
require 'json'


class PreferenceUtils

  @@url = "http://testnet-uk.activeledger.io:5260"
  @@sse_url = "http://testnet-uk.activeledger.io:5261"
  @@t_url = "http://testnet-uk.activeledger.io:5260/a/status"

  @@onboard_id = ""
  @@onboard_name = ""


  # setting up connection for http request
  # requires (protocol, url and port) as an input parameters and convert them into url
  def PreferenceUtils.setConnection(protocol, url ,port)
    @@url =  "#{protocol}://#{url}:#{port}"
  end

  def PreferenceUtils.getConnection
    return @@url
  end

  def PreferenceUtils.territorialityDetailsURL
    return @@t_url
  end

  def PreferenceUtils.sseURL
    return @@sse_url
  end

  def PreferenceUtils.convertJSONToString(json)
    return json.to_json
  end

  def PreferenceUtils.getOnboardID
    return @@onboard_id
  end
  
  def PreferenceUtils.getOnboardName
    return @@onboard_name
  end

  # function takes filename and key as an input, writes the key into the file and saves the file to current directory
  def PreferenceUtils.writeKeyInFile(filename,key)
    
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

  # function takes filename and key as an input, writes the key into the file and saves the file to current directory
  def PreferenceUtils.extractStreamID(onboardResponse)
    
    res_json = JSON.parse(onboardResponse)
   
    @@onboard_id = res_json['$streams']['new'][0]['id']
    @@onboard_name = res_json['$streams']['new'][0]['name']

  end


end
