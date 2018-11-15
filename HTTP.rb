class HTTP

  def doHttpHit(connection, transaction)

    # http hit
    uri = URI.parse(connection)
    header = {'Content-Type': 'text/json'}

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = transaction

    # Send the request
    response = http.request(request)

    return response
  end

end