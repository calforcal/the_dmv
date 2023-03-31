require 'date'

class Facility
  attr_reader :name, :address, :phone, :services, :registered_vehicles, :collected_fees

  def initialize(hash)
    @name = hash[:name]
    @address = hash[:address]
    @phone = hash[:phone]
    @services = []
    @registered_vehicles = []
    @collected_fees = 0
  end

  def add_service(service)
    @services << service
  end

  def register_vehicle(vehicle, service="Vehicle Registration")
    if self.performs_service?(service)
      vehicle.registration_date = Date.today
      @registered_vehicles << vehicle
      if vehicle.antique?
        @collected_fees += 25
        vehicle.plate_type = :antique
      elsif vehicle.electric_vehicle?
        @collected_fees += 200
        vehicle.plate_type = :ev
      else
        @collected_fees += 100
        vehicle.plate_type = :regular
      end
    else
      return nil
    end
    @registered_vehicles
  end

  def administer_written_test(registrant, service="Written Test")
    if self.performs_service?(service)
      if registrant.age >= 16 && registrant.permit?
        registrant.license_data[:written] = true
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def administer_road_test(registrant, service="Road Test")
    if self.performs_service?(service)
      if registrant.license_data[:written] == true
        registrant.license_data[:license] = true
      else
        return false
      end
    else
      return false
    end
  end

  def renew_drivers_license(registrant, service="Renew License")
    if self.performs_service?(service)
      if registrant.license_data[:license] == true
        registrant.license_data[:renewed] = true
      else
        return false
      end
    else
      return false
    end
  end

  def performs_service?(service)
    true if @services.include?(service)
  end
end
