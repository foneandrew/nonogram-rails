require 'rails_helper'

RSpec.describe User, :type => :model do
  fixtures :users

  describe '#valid?' do
    let(:user) { users(:user_1) }

    context 'when given a valid name and email' do
      it 'is valid' do
        expect(user.valid?).to be_truthy
      end
    end

    context 'when created without a name' do
      before do
        user.name = nil
      end

      it 'is not valid' do
        expect(user.valid?).to be_falsey
      end
    end

    context 'when created without a valid email' do
      context 'when the email is missing' do
        before do
          user.email = nil
        end

        it 'is not valid' do
          expect(user.valid?).to be_falsey
        end
      end

      context 'when the email is not an actual email' do
        before do
          user.email = "nil"
        end

        it 'is not valid' do
          expect(user.valid?).to be_falsey
        end
      end
    end
  end
end
