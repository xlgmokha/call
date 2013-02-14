require "spec_helper"

describe DatabaseGateway do
  let(:connection_factory) { DatabaseConnectionFactory.new(DatabaseConfiguration.new, SequelConnectionProvider.new) }
  let(:sut) { DatabaseGateway.new(connection_factory) }

  before :each do
    TestDatabaseGateway.connection.create_table :users do
      primary_key :id
      String :name
    end
  end
  after(:each) do
    TestDatabaseGateway.connection.drop_table :users
  end

  context "when executing a query against the database" do
    before(:each) do
      TestDatabaseGateway.connection.from(:users).insert(:name => 'mo')
    end
    it "should be able to return a result set" do
      query = DatabaseQuery.new { |c| c.from(:users).all }
      results = sut.run(query)
      results.should == [:id => 1, :name => 'mo']
    end
  end
  context "when executing a command against the database" do
    it "should run the command against the open connection" do
      command = DatabaseCommand.new { |c| c.from(:users).insert(:name => 'mo') }
      sut.run(command)
      TestDatabaseGateway.connection.from(:users).count.should == 1
    end
  end
end