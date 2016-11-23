ENV["RACK_ENV"] = "test"
require_relative "../lib/api"

describe Api do
  def app
    described_class.new({config: "stuff"})
  end

  describe "/" do
    describe "GET" do
      it "responds with 200" do
        get "/"

        expect(last_response).to be_ok
      end
    end
  end

  describe "/storage/key" do
    describe "GET" do
      let(:redis) { double }

      before do
        allow(RedisFactory).to receive(:redis).and_return redis
      end

      it "returns the value of the key from the storage" do
        expect(redis).to receive(:get).with("key").and_return "foobar"
        get "/storage/key"

        expect(last_response).to be_ok
        expect(last_response.body).to eq "\"foobar\""
      end
    end

    describe "POST" do
      let(:redis) { double }

      before do
        allow(RedisFactory).to receive(:redis).and_return redis
      end

      it "sets the value of the key in the storage" do
        expect(redis).to receive(:set).with("key", "foobar")
        post "/storage/key", '{"value":"foobar"}'

        expect(last_response).to be_ok
      end
    end

    describe "DELETE" do
      let(:redis) { double }

      before do
        allow(RedisFactory).to receive(:redis).and_return redis
      end

      it "deletes the value of the key in the storage" do
        expect(redis).to receive(:del).with("key")
        delete "/storage/key"

        expect(last_response).to be_ok
      end
    end
  end
end

