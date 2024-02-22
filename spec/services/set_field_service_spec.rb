# frozen_string_literal: true

require 'rails_helper'

describe SetFieldService do
  describe '#call' do
    subject { described_class.new.call(**data) }
    let(:user) { create(:user, verified: 1) }

    context 'field_name is email' do
      context 'email is valid' do
        before { stub_email_validator }

        let(:data) { { customer: user, field_name: 'email', new_value: 'test@gmail.com' } }

        it 'updates the email field' do
          expect{ subject }.to change { user.email }.to(data[:new_value])
        end

        it 'formats the email before update' do
          data[:new_value] = '     tEsT@gmaIl.com  '

          expect { subject }.to change { user.email }.to('test@gmail.com')
        end

        it 'marks customer as not verified' do
          expect { subject }.to change { user.verified }.to(0)
        end

        it 'returns valid result after update' do
          expect(subject).to eq({})
        end

        context 'when email already exists' do
          let!(:another_user) { create(:user, email: 'test@gmail.com') }

          it 'returns an error' do
            expect(subject).to include(error: 'Email already exists.')
          end
        end
      end

      context 'email is blank' do
        let(:data) { { customer: user, field_name: 'email', new_value: '' } }

        it 'returns an error' do
          expect(subject).to include(error: 'You need to specify an email for this customer.')
        end
      end

      context 'email is invalid' do
        let(:data) { { customer: user, field_name: 'email', new_value: 'something' } }

        it 'returns an error' do
          stub_email_validator(result: false)
          expect(subject).to include(error: "Can't save email. Invalid value: '#{data[:new_value]}'")
        end
      end
    end

    context 'field_name is first_name' do
      let(:data) { { customer: user, field_name: 'first_name', new_value: 'Some Name' } }

      it 'updates the first_name field' do
        expect { subject }.to change { user.first_name }.to(data[:new_value])
      end

      it 'strips unnecessary spaces before update' do
        data[:new_value] = "  #{data[:new_value]}   "
        expect { subject }.to change { user.first_name }.to(data[:new_value].strip)
      end

      it 'returns valid result after update' do
        expect(subject).to eq({})
      end
    end

    context 'field_name is last_name' do
      let(:data) { { customer: user, field_name: 'last_name', new_value: 'Some Last Name' } }

      it 'updates the last_name field' do
        expect { subject }.to change { user.last_name }.to(data[:new_value])
      end

      it 'strips unnecessary spaces before update' do
        data[:new_value] = "  #{data[:new_value]}   "
        expect { subject }.to change { user.last_name }.to(data[:new_value].strip)
      end

      it 'returns valid result after update' do
        expect(subject).to eq({})
      end
    end

    context 'field_name is phone' do
      let(:data) { { customer: user, field_name: 'phone', new_value: '+9955232314' } }

      it 'updates the phone field' do
        expect { subject }.to change { user.phone }.to(data[:new_value])
      end

      it 'strips unnecessary spaces before update' do
        data[:new_value] = "  #{data[:new_value]}   "
        expect { subject }.to change { user.phone }.to(data[:new_value].strip)
      end

      it 'returns valid result after update' do
        expect(subject).to eq({})
      end
    end

    context 'field_name is title' do
      let(:data) { { customer: user, field_name: 'title', new_value: 'Some Title' } }

      it 'updates the title field' do
        expect { subject }.to change { user.title }.to(data[:new_value])
      end

      it 'strips unnecessary spaces before update' do
        data[:new_value] = "  #{data[:new_value]}   "
        expect { subject }.to change { user.title }.to(data[:new_value].strip)
      end

      it 'returns valid result after update' do
        expect(subject).to eq({})
      end
    end

    context 'field_name is role' do
      let(:data) { { customer: user, field_name: 'role', new_value: 'Some role' } }

      it 'updates the role field' do
        expect { subject }.to change { user.role }.to(data[:new_value])
      end

      it 'strips unnecessary spaces before update' do
        data[:new_value] = "  #{data[:new_value]}   "
        expect { subject }.to change { user.role }.to(data[:new_value].strip)
      end

      it 'returns valid result after update' do
        expect(subject).to eq({})
      end
    end

    context 'field_name is score' do
      let(:data) { { customer: user, field_name: 'score', new_value: 53 } }

      it 'updates the score field' do
        expect { subject }.to change { user.score }.to(data[:new_value])
      end

      it 'converts string to integer before save' do
        data[:new_value] = " #{data[:new_value]}   "
        expect { subject }.to change { user.score }.to(data[:new_value].strip.to_i)
      end

      it 'sets score to 0 if incorrect string is submitted' do
        data[:new_value] = ' asda3sd '
        expect { subject }.to change { user.score }.to(0)
      end

      it 'sets score to first number in the string if incorrect string starts from number' do
        data[:new_value] = ' 34asda3sd '
        expect { subject }.to change { user.score }.to(34)
      end

      it 'returns valid result after update' do
        expect(subject).to eq({})
      end
    end

    context 'field_name is unknown' do
      let(:data) { { customer: user, field_name: 'some_other_field', new_value: 'Some value' } }

      it 'returns an error' do
        expect(subject).to include(error: "Unknown field: '#{data[:field_name]}'")
      end
    end
  end

  def stub_email_validator(result: true)
    stub_const('EmailValidator', StubbedEmailValidator.new(result))
  end
end

StubbedEmailValidator = Struct.new(:result) do
  def valid?(_email)
    result
  end
end
