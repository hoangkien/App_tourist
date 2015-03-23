class Api::UsersController < ApplicationController
	skip_before_action :authorize
	require 'gcm'
	def list
		#check the code device already in the list
		#check joined the tour
		#get tour info
		#get list users
		 unless params[:device_code].blank?
			@check_exits = Device.find_by(code: params[:device_code])
			if @check_exits
				if @check_exits.status == false
					render json:{status:0, message:"Device not used",traveller_in_tour:[]}
				else
					#get tourguide info using device
					@tourguide = Tourguide.find_by(device_id: @check_exits.id )
					#get traveller info using device
					@traveller = Traveller.find_by(device_id:@check_exits.id)
					if @tourguide#tourguide
							#get tour info
							@tour = @tourguide.tours.last
							#get list travellers
							@traveller_list = @tour.travellers
							@traveller_in_tour = []
							@traveller_list.each do |travel|
								@device = Device.find(travel.device_id)
								@traveller_in_tour << {     id:travel.id ,
											                name: travel.name,
											                phone: travel.phone,
											                lat:@device.lat == nil ? "" : @device.lat,
															lng:@device.lng == nil ? "" : @device.lng,
											                address: travel.address,
											                gender: travel.gender == false ? "male" : "female", 
											                email: travel.email,
											                images:"http://"+request.host_with_port+"/assets/images_travellers/"+travel.images
										            }
										        end
							#render mobile list travellers
							render json:{status:0,message:"success",traveller_in_tour:@traveller_in_tour}
					else
						#get traveller info using device
						@tour = @traveller.tours.last
						#get list tour guides
						@tourguide_list = @tour.tourguides
						@tourguide_in_tour = []
						@tourguide_list.each do |tourguide|
							@device = Device.find(tourguide.device_id)
							@tourguide_in_tour << {     id:tourguide.id ,
										                name: tourguide.name,
										                phone: tourguide.phone,
										                lat:@device.lat == nil ? "" : @device.lat,
														lng:@device.lng == nil ? "" : @device.lng,
										                address: tourguide.address,
										                gender: tourguide.gender == false ? "male" : "female", 
										                email: tourguide.email,
										                images:"http://"+request.host_with_port+"/assets/images_tourguide/"+tourguide.images
								            }
										end
						#render mobile  list tourguides
						render json:{status:0,message:"success",tourguide_in_tour:@tourguide_in_tour}
					end
				end
			else
				render json:{status: 9, message:"Device code  invalid"}
			end
		else
			render json:{status:1,message:"Missing device code"}
		end
	end
	def update_position
		unless params[:device_code].blank?
			@device = Device.find_by(code:params[:device_code])
			if @device
				# render json:{device:@device}
				# render json:{post:post_params}
				# @post_params = post_params
				if post_params[:lat].blank? or post_params[:lng].blank?
					render json:{status:7, message:"Missing information lat or lng"}
				else
					if @device.update_attributes(post_params)
						render json:{status:0,message:"success"}
					else
						render json:{status:6,message:"Can't update position"}
					end
					
				end
			else
				render json:{status: 107, message:"Device code  invalid"}
			end
		else
			render json:{status:1,message:"Missing device code"}
		end

	end
	def feedback
		# render json:{status:0,message:params_feedback[:rating_bar]}
		unless params[:device_code].blank?
			@device = Device.find_by(code:params[:device_code])
			# @traveller = Traveller.where(device_id:@device.id).first
			# @tour = @traveller.tours.first
			@company = @device.company
		 	@params_feedback = params_feedback
		# 	# @params_feedback[:traveller_id] = @traveller.id
		# 	# @params_feedback[:tour_id] = @tour.id
			@params_feedback[:company_id] = @company.id
			rating_bar = params[:rating_bar].to_i
			if (1..2.4).include?rating_bar
				@params_feedback[:quantiy_service] = "Bad"
			elsif(4.5..5).include?rating_bar
				@params_feedback[:quantiy_service] ="Excellent"
			elsif (2.5..4.4).include?rating_bar
				@params_feedback[:quantiy_service] = "Good"
			end
			# render json:{feedback:@params_feedback}
			@feedback = Feedback.new(@params_feedback)
			if @feedback.save
				render json:{status:0, message:"success"}
			else
				render json:{status:2,message:"Can't send feedback"}
			end
		else
			render json:{status:1,message:"Missing device code"}
		end

	end
	def push
		if params[:device_code].blank?  or params[:message].blank?
				render json:{ status:102 , message:"Not found information Device or message"}
		else
			# device
			@device = Device.find_by(code:params[:device_code])
			if @device.nil? or @device.status == 0
			 	render json:{status: 101, message:"Device code invalid or Device not used "}
			else
				# render json:{device:@device}
			# # # # #get Tourguide info
			 	@tourguide = Tourguide.find_by(device_id:@device.id)
			 	@traveller = Traveller.find_by(device_id:@device.id)
			 	# render  json:{tourguide:@tourguide}
				if @tourguide
			 		# render json:{status:102, message:"Device not used"}
			 			@tour = @tourguide.tours.last
						# # # #get list travellers
						# render json:{tour:@tour}
						@traveller_list = @tour.travellers
						# render json:{traveller_list:@traveller_list}
						message = params[:message]
						# #khoi tao GCM
						gcm = GCM.new("AIzaSyDdRUrekXqXoRSyRGCESEwNAx3M0qhLmhk")
						#get list registration_id traveller
						@registration_ids = []
						@traveller_list.each do |traveller|
							reg_id = Device.find(traveller.device_id).reg_id
							@registration_ids << reg_id
						end
						# registration_ids=["APA91bH1mNiGuk0CQt2h-wOGtsXEltKb_Ey4dYia0hF2RfmqtorVDwj3XpXP1VSdDp6N84ckiTTV3ITHM8j8n9M2fUUwLo8hlvmVDeZ0UpWv7-Jvdp2KT1kDtnE7mCIUFFS_59CdUFDPnEZUOQcrAei9IBAhtMpVUQ"]
						#get messeage
						options = {data: {message:message}, collapse_key: "updated_score"}
						#send GCM
						response = gcm.send(@registration_ids,options)
						if response[:response] == "success"
							render json:{status:0, message:"success"}
						else
							render json:{status:108, message:"Can not send message"}
						end
			 	else#traveller
			 			@tour = @traveller.tours.last
			 			@tourguide_list = @tour.tourguides
			 			message = params[:message]
			 			gcm = GCM.new("AIzaSyDdRUrekXqXoRSyRGCESEwNAx3M0qhLmhk")
			 			@registration_ids = []
						@tourguide_list.each do |tourguide|
							reg_id = Device.find(tourguide.device_id).reg_id
							@registration_ids << reg_id
						end
						# # #get tour info
						options = {data: {message:message}, collapse_key: "updated_score"}
						response = gcm.send(@registration_ids,options)
						if response[:response] == "success"
							render json:{status:0, message:"success"}
						else
							render json:{status:108, message:"Can not send message"}
						end
				end
			end
		end
	end
	private
	def params_feedback
		params.permit(:name,:tour_name,:phone,:comment)
	end
	def post_params
		params.permit(:lat,:lng)
	end
end