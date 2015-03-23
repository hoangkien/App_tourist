# module Api
	class Api::DevicesController < ApplicationController
		skip_before_action :authorize 
		skip_before_filter  :verify_authenticity_token
		#function get device info
		def show
			#check params device_code
			unless params[:device_code].blank? or params[:regId_code].blank?
				#check device exits
				@device = Device.find_by(code: params[:device_code])
				#neu co
				if @device
					if @device.status == false
							#render status =002
							render json:{status: 0, message:"Device not used",details:{name_device:@device.name,notification: 1,info:{
																			id:"",
																			name:"",
																			address:"",
																			tour_name:"",
																			lat:"",
																			lng:"",
																			phone:"",
																			device_id:@device.id
																			}
																		}
																}
					else
						if @device.reg_id.blank?
							@device.update(reg_id:params[:regId_code])
							#check status
							# if don't joined tour
							#joined tour
							@tourguide = Tourguide.find_by(device_id:@device.id)
							# @tourguide_info = @tourguide
							# @tourguide_info[:abc] = @device.lat
							# @tourguide[:lng] = @device.lng
							if  @tourguide #tourguide
								#render tourguide info
									render json:{ 
													status:0,message: "Success",details:{
																		group: 1,name_device: @device.name,notification:2,info:{
																			id:@tourguide[:id],
																			name:@tourguide[:name],
																			address:@tourguide[:address],
																			tour_name:@tourguide.tours.first.name,
																			images:"http://"+request.host_with_port+"/assets/images_tourguide/"+@tourguide.images,
																			lat:@device.lat == nil ? "" : @device.lat,
																			lng:@device.lng == nil ? "" : @device.lng,
																			phone:@tourguide[:phone],
																			device_id:@device.id
																			}
													}
												}
							else#traveller
								# render json:{url:request.host_with_port}
								#get traveller info
								@traveller = Traveller.find_by(device_id:@device.id)
								#render traveller info
								render json:{ 
												status:0,message: "Success",details:{
													group: 0,name_device: @device.name,notification:2,info:{
														id:@traveller[:id],
														name:@traveller[:name],
														address:@traveller[:address],
														tour_name:@traveller.tours.first.name,
														images:"http://"+request.host_with_port+"/assets/images_travellers/"+@traveller.images,
														lat:@device.lat == nil ? "" : @device.lat,
														lng:@device.lng == nil ? "" : @device.lng,
														phone:@traveller[:phone],
														device_id:@device.id
													}
												}
											}
							end
						elsif @device.reg_id != params[:regId_code]
							render json:{ status: 103, message:"RegId invalid "}
						else
							#joined tour
							@tourguide = Tourguide.find_by(device_id:@device.id)
							# @tourguide_info = @tourguide
							# @tourguide_info[:abc] = @device.lat
							# @tourguide[:lng] = @device.lng
							unless  @tourguide == nil #tourguide
								#render tourguide info
									render json:{ 
													status:0,message: "Success",details:{
																		group: 1,name_device: @device.name,notification:2,info:{
																			id:@tourguide[:id],
																			name:@tourguide[:name],
																			address:@tourguide[:address],
																			tour_name:@tourguide.tours.first.name,
																			images:"http://"+request.host_with_port+"/assets/images_tourguide/"+@tourguide.images,
																			lat:@device.lat == nil ? "" : @device.lat,
																			lng:@device.lng == nil ? "" : @device.lng,
																			phone:@tourguide[:phone],
																			device_id:@device.id
																			}
													}
												}
							else#traveller
								# render json:{url:request.host_with_port}
								#get traveller info
								@traveller = Traveller.find_by(device_id:@device.id)
								#render traveller info
								render json:{ 
												status:0,message: "Success",details:{
													group: 0,name_device: @device.name,notification:2,info:{
														id:@traveller[:id],
														name:@traveller[:name],
														address:@traveller[:address],
														tour_name:@traveller.tours.first.name,
														images:"http://"+request.host_with_port+"/assets/images_travellers/"+@traveller.images,
														lat:@device.lat == nil ? "" : @device.lat,
														lng:@device.lng == nil ? "" : @device.lng,
														phone:@traveller[:phone],
														device_id:@device.id
													}
												}
											}
							end
						end
					end
				else #don't already system
						#render status = 001
						render json:{status:0,message:"Device not already in system",details:{
																		group: "",name_device:"",notification:0,info:{
																			id:"",
																			name:"",
																			address:"",
																			tour_name:"",
																			lat:"",
																			lng:"",
																			phone:"",
																			device_id:""
																			}
																		}
																	}
				end
			else
				render json:{status: 104, message:"Not found information device code or regID code"}
			end
		end
		#function add device
		def create
			unless params[:company_code].blank? or params[:device_code].blank? 
				#check company code
				@check_company = Company.find_by(code: params[:company_code])
				if @check_company
					unless params[:device_code] == ""
						@check_code = Device.find_by(code:params[:device_code])
						if @check_code
							render json:{status: 5, message:"Device code already exist"}
						else
							@device = Device.new(name:params[:device_code],code:params[:device_code],company_id:@check_company.id,status:0)
							@device.save
							render json: {status: 0, message:"Success"}
						end
					else
						render json:{status:1,message:"Missing device code"}
					end
				else
					render json:{status: 4,message:"Company code invalid"}
				end
			else
				 render json:{status:3, message:"Not found information Device or Company.	"}
			end
		end
	# end	
end