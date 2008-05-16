require 'helper'

class AdvertiserTest < Test::Unit::TestCase
  include OpenX::Services

  def setup
    @session = Session.new(TEST_URL)
    assert_nothing_raised {
      @session.create('admin', 'vendo')
    }
    @agency = agency
  end

  def destroy
    assert_nothing_raised {
      @agency.destroy
      @session.destroy
    }
  end

  def test_create_advertiser
    advertiser = nil
    assert_nothing_raised {
      advertiser = Advertiser.create!(init_params.merge({
        :session  => @session,
        :agency   => @agency,
      }))
    }
    assert_not_nil advertiser
    init_params.each do |k,v|
      assert_equal(v, advertiser.send(:"#{k}"))
    end
  end

  def test_create_advertiser_with_agency
    advertiser = nil
    assert_nothing_raised {
      advertiser = @agency.create_advertiser!(init_params)
    }
    assert_not_nil advertiser
    init_params.each do |k,v|
      assert_equal(v, advertiser.send(:"#{k}"))
    end
  end

  def test_find_advertiser
    advertiser = nil
    assert_nothing_raised {
      advertiser = @agency.create_advertiser!(init_params)
    }
    assert_not_nil advertiser

    advertiser = Advertiser.find(@session, advertiser.id)
    assert_not_nil advertiser
    init_params.each do |k,v|
      assert_equal(v, advertiser.send(:"#{k}"))
    end
  end

  def test_find_all_advertisers
    advertiser = nil
    assert_nothing_raised {
      advertiser = @agency.create_advertiser!(init_params)
    }
    assert_not_nil advertiser

    advertisers = Advertiser.find(@session, :all, @agency.id)

    advertiser = advertisers.find { |a| a.id == advertiser.id }
    assert_not_nil advertiser
    init_params.each do |k,v|
      assert_equal(v, advertiser.send(:"#{k}"))
    end
  end

  def init_params
    {
      :name         => 'Test advertiser',
      :contact_name => 'Contact name',
      :email        => 'email@example.com',
    }
  end

  def agency
    Agency.create!(
      {
        :name         => 'Testing!',
        :contact_name => 'Contact Name!',
        :email        => 'foo@bar.com'
      }.merge({:session => @session})
    )
  end
end
