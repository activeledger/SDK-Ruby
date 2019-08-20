=begin
Copyright 2018 Catamorphic, Co.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end
require 'ld-eventsource'

class SSEHandler

    def sshclient(url)

        sse_client = SSE::Client.new(url) 
        return sse_client

    end 


    def getevent(sseClient)
         sseClient.on_event { |event|
            $eventType = event.type
            $eventData = event.data
            puts "event2: #{event.type}, #{event.data}"
        }
    end


end