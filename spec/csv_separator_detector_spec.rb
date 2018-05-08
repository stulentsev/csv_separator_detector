require "spec_helper"

RSpec.describe ::CsvSeparatorDetector do
  let(:instance) { described_class.new(input) }
  let(:detected_separator) { instance.call }

  context 'commas' do
    let(:input) {
      <<-TEXT
_key_,_value_,_description_
foo,1,asdadsf
      TEXT
    }

    it { expect(detected_separator).to eq ',' }
  end

  context 'differing number of columns' do
    let(:input) {
      <<-TEXT
_key_,_value_,_description_
foo,1
      TEXT
    }

    it { expect(detected_separator).to eq ',' }
  end

  context 'ambiguous separator' do
    let(:input) {
      <<-TEXT
_key_;_value_,_description_
KEY1;"Hello world 1";descr
KEY 2;"Hello world 2"
      TEXT
    }

    it { expect{detected_separator}.to raise_error CsvSeparatorDetector::Error }
  end

  context 'quoted alternate separators dont affect detection' do
    let(:input) {
      <<-TEXT
_key_;"_value_,_description_"
      TEXT
    }

    it { expect(detected_separator).to eq ';' }
  end

  context 'semicolons' do
    let(:input) {
      <<-TEXT
_title_;value;description
foo;1;asdadsf
      TEXT
    }

    it { expect(detected_separator).to eq ';' }
  end

  context 'tabs' do
    let(:input) {
      <<-TEXT
_key_\t_value_\t_description_
foo\t1\tasdadsf
      TEXT
    }

    it { expect(detected_separator).to eq "\t" }
  end

  context 'pipe' do
    let(:input) {
      <<-TEXT
_key_|_value_|_description_
foo|1|asdadsf
      TEXT
    }

    it { expect(detected_separator).to eq '|' }
  end

  context 'mixed' do
    let(:input) {
      <<-TEXT
_key_;_value_;description,etc.
foo;1;asdadsf
      TEXT
    }

    it { expect(detected_separator).to eq ';' }
  end

  context 'empty string' do
    let(:input) { '' }
    it { expect{detected_separator}.to raise_error CsvSeparatorDetector::Error }
  end

  context 'blank string' do
    let(:input) { "    \n" }
    it { expect{detected_separator}.to raise_error CsvSeparatorDetector::Error }
  end

  context 'multiline single cell input' do
    let(:input) {
      <<~CSV
        "foo
        bar
        baz"
      CSV
    }

    it { expect{detected_separator}.to raise_error CsvSeparatorDetector::Error }
  end

  context 'multiline cells with CR delimiter' do
    let(:input) {
      <<~CSV
      1234,"foo\rbar\rbaz"
      4567,"hello\rworld"
      CSV
    }

    it { expect(detected_separator).to eq ',' }
  end

  context 'no input' do
    let(:input) { nil }
    it { expect{detected_separator}.to raise_error ArgumentError }
  end
end











