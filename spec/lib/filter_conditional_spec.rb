require 'spec_helper'

describe Fluent::ConditionalFilter do
  describe '#configure' do

    context "success" do
      let(:conf) {
        %[
          key_pattern @example\.com$
          condition   10
          filter      numeric_upward
        ]
      }

      let(:driver) { Fluent::Test::FilterTestDriver.new(described_class, 'test').configure(conf) }
      subject {
        driver
      }

      it {
        expect(subject.instance).to be_an_instance_of described_class
        expect(subject.instance.key_pattern).to be == "@example\.com$"
        expect(subject.instance.instance_variable_get(:@key_pattern_regexp)).to be == /@example.com$/
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
            Fluent::Test::FilterTestDriver.new(described_class, 'test').configure(conf)
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
            Fluent::Test::FilterTestDriver.new(described_class, 'test').configure(conf)
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
            Fluent::Test::FilterTestDriver.new(described_class, 'test').configure(conf)
          }.to raise_error(Fluent::ConfigError)
        }
      end
    end
  end

  describe "#filter" do
    context('numeric_upward') do
      let(:conf) {
        %[
          key_pattern @example.com$
          condition   10
          filter      numeric_upward
        ]
      }

      let(:driver) { Fluent::Test::FilterTestDriver.new(described_class, 'test').configure(conf) }

      context('with 0 matched key/value pair') do
        before {
          driver.run {
            driver.filter('foo@example.com' => 8, 'bar@example.com' => 6, 'baz@baz.com' => 15)
          }
        }

        it {
          expect(driver.filtered_as_array[0]).to be_nil
        }
      end

      context('with 1 matched key/value pair') do
        before {
          driver.run {
            driver.filter('foo@example.com' => 12, 'bar@example.com' => 6, 'baz@baz.com' => 15)
          }
        }

        it {
          expect(driver.filtered_as_array[0][2].keys.length).to be == 1
        }
      end

      context('with 2 matched key/value pairs') do
        before {
          driver.run {
            driver.filter('foo@example.com' => 12, 'bar@example.com' => 10, 'baz@baz.com' => 15)
          }
        }

        it {
          expect(driver.filtered_as_array[0][2].keys.length).to be == 2
        }
      end
    end

    context('numeric_downward') do
      let(:conf) {
        %[
          key_pattern @example.com$
          condition   10
          filter      numeric_downward
        ]
      }

      let(:driver) { Fluent::Test::FilterTestDriver.new(described_class, 'test').configure(conf) }

      context('with 0 matched key/value pair') do
        before {
          driver.run {
            driver.filter('foo@example.com' => 18, 'bar@example.com' => 26, 'baz@baz.com' => 15)
          }
        }

        it {
          expect(driver.filtered_as_array[0]).to be_nil
        }
      end

      context('with 1 matched key/value pair') do
        before {
          driver.run {
            driver.filter('foo@example.com' => 11, 'bar@example.com' => 6, 'baz@baz.com' => 5)
          }
        }

        it {
          expect(driver.filtered_as_array[0][2].keys.length).to be == 1
        }
      end

      context('with 2 matched key/value pairs') do
        before {
          driver.run {
            driver.filter('foo@example.com' => 10, 'bar@example.com' => 5, 'baz@baz.com' => 5)
          }
        }

        it {
          expect(driver.filtered_as_array[0][2].keys.length).to be == 2
        }
      end
    end

    context('string_match') do
      let(:conf) {
        %[
          key_pattern @example.com$
          condition   (staff|user)
          filter      string_match
        ]
      }

      let(:driver) { Fluent::Test::FilterTestDriver.new(described_class, 'test').configure(conf) }

      context('with 0 matched key/value pair') do
        before {
          driver.run {
            driver.filter('foo@example.com' => 'guest', 'bar@example.com' => 'guest', 'baz@baz.com' => 'staff')
          }
        }

        it {
          expect(driver.filtered_as_array[0]).to be_nil
        }
      end

      context('with 1 matched key/value pair') do
        before {
          driver.run {
            driver.filter('foo@example.com' => 'staff', 'bar@example.com' => 'guest', 'baz@baz.com' => 'user')
          }
        }

        it {
          expect(driver.filtered_as_array[0][2].keys.length).to be == 1
        }
      end

      context('with 2 matched key/value pairs') do
        before {
          driver.run {
            driver.filter('foo@example.com' => 'staff', 'bar@example.com' => 'user', 'baz@baz.com' => 'staff')
          }
        }

        it {
          expect(driver.filtered_as_array[0][2].keys.length).to be == 2
        }
      end
    end
  end
end
