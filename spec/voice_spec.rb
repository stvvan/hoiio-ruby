#Copyright (C) 2012 Hoiio Pte Ltd (http://www.hoiio.com)
#
#Permission is hereby granted, free of charge, to any person
#obtaining a copy of this software and associated documentation
#files (the "Software"), to deal in the Software without
#restriction, including without limitation the rights to use,
#                                                        copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the
#Software is furnished to do so, subject to the following
#conditions:
#
#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#OTHER DEALINGS IN THE SOFTWARE.

require 'spec_helper'

VOICE_CALL_RESPONSE = {:status => SUCCESS, :txn_ref => "test-1"}
VOICE_CONFERENCE_RESPONSE = {:status => SUCCESS, :txn_ref => "test-1"}
VOICE_HANGUP_RESPONSE = {:status => SUCCESS}
VOICE_GET_HISTORY_RESPONSE = {:status => SUCCESS, :entries_count => "1"}
VOICE_GET_RATE_RESPONSE = {:status => SUCCESS, :rate => "0.03", :currency => "SGD"}
VOICE_QUERY_STATUS_RESPONSE = {:status => SUCCESS, :call_status_dest1 => "answered", :currency => "SGD"}

FakeWeb.register_uri :post, construct_fakeweb_uri("/voice/call"), :body => VOICE_CALL_RESPONSE.to_json
FakeWeb.register_uri :post, construct_fakeweb_uri("/voice/conference"), :body => VOICE_CONFERENCE_RESPONSE.to_json
FakeWeb.register_uri :post, construct_fakeweb_uri("/voice/hangup"), :body => VOICE_HANGUP_RESPONSE.to_json
FakeWeb.register_uri :post, construct_fakeweb_uri("/voice/get_history"), :body => VOICE_GET_HISTORY_RESPONSE.to_json
FakeWeb.register_uri :post, construct_fakeweb_uri("/voice/get_rate"), :body => VOICE_GET_RATE_RESPONSE.to_json
FakeWeb.register_uri :post, construct_fakeweb_uri("/voice/query_status"), :body => VOICE_QUERY_STATUS_RESPONSE.to_json


describe Hoiio::Voice do

  it 'should make a call and return txn_ref' do
    response = CLIENT.voice.call({:dest2 => TEST_PHONE})
    check_status response
    check_txn_ref response
  end

  it 'should set up  conference call' do
    response = CLIENT.voice.conference({:dest => TEST_PHONE})
    check_status response
    check_txn_ref response
  end

  it 'should hang up a call' do
    response = CLIENT.voice.hangup({:txn_ref => "test"})
    check_status response
  end

  it 'should return history' do
    response = CLIENT.voice.get_history
    check_status response
    response['entries_count'].should == "1"
  end

  it 'should return call rate' do
    response = CLIENT.voice.get_rate({:dest1 => "+1231231", :dest2 => "+23123132"})
    check_status response
    response["currency"].should == "SGD"
    response["rate"].should == "0.03"
  end

  it 'should query call status' do
    response = CLIENT.voice.query_status({:txn_ref => "test"})
    check_status response
    response["currency"].should == "SGD"
    response["call_status_dest1"].should == "answered"
  end

end