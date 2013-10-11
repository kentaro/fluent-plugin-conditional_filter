require 'spec_helper'

describe Fluent::ConditionalFilterOutput do
  describe '#configure' do

    context "success" do
      let(:conf) {
        %[
          key_pattern @example\.com$
          condition   10
          filter      numeric_upward
        ]
      }

      let(:driver) { Fluent::Test::OutputTestDriver.new(described_class, 'test').configure(conf) }
      subject {
        driver.instance
      }

      it {
        expect(subject).to be_an_instance_of described_class
        expect(subject.key_pattern).to be == "@example\.com$"
        expect(subject.instance_variable_get(:@key_pattern_regexp)).to be == /@example.com$/
      }
    end

    context "failure" do
      context 'key_pattern not set' do
        let(:conf) {
          %[
            condition   10
            filter      numeric_upward
          ]
        }

        it {
          expect {
            Fluent::Test::OutputTestDriver.new(described_class, 'test').configure(conf)
          }.to raise_error(Fluent::ConfigError)
        }
      end

      context 'condition not set' do
        let(:conf) {
          %[
            key_pattern @example.com$
            filter      numeric_upward
          ]
        }

        it {
          expect {
            Fluent::Test::OutputTestDriver.new(described_class, 'test').configure(conf)
          }.to raise_error(Fluent::ConfigError)
        }
      end

      context 'filter not set' do
        let(:conf) {
          %[
            key_pattern @example.com$
            condition   10
          ]
        }

        it {
          expect {
            Fluent::Test::OutputTestDriver.new(described_class, 'test').configure(conf)
          }.to raise_error(Fluent::ConfigError)
        }
      end
    end
  end

  describe "#emit" do
    context('numeric_upward') do
      let(:conf) {
        %[
          key_pattern @example.com$
          condition   10
          filter      numeric_upward
        ]
      }

      let(:driver) { Fluent::Test::OutputTestDriver.new(described_class, 'test').configure(conf) }
      subject {
        driver.instance
      }

      context('with 0 matched key/value pair') do
        before {
          driver.run {
            driver.emit('foo@example.com' => 8, 'bar@example.com' => 6, 'baz@baz.com' => 15)
          }
        }

        it {
          expect(driver.emits[0]).to be_nil
        }
      end

      context('with 1 matched key/value pair') do
        before {
          driver.run {
            driver.emit('foo@example.com' => 12, 'bar@example.com' => 6, 'baz@baz.com' => 15)
          }
        }

        it {
          expect(driver.emits[0][2].keys.length).to be == 1
        }
      end

      context('with 2 matched key/value pairs') do
        before {
          driver.run {
            driver.emit('foo@example.com' => 12, 'bar@example.com' => 10, 'baz@baz.com' => 15)
          }
        }

        it {
          expect(driver.emits[0][2].keys.length).to be == 2
        }
      end
    end
  end
end

