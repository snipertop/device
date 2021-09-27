require 'csv'

class StaffsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_staff, only: %i[ show edit update destroy ]
  
  def import
    csv_string = params[:csv_file].read.force_encoding('utf-8')

    success = 0
    failed_records = []

    CSV.parse(csv_string) do |row|
      staff = Staff.new( 
                          :number => row[0],
                          :name => row[1],
                          :department => row[2],
                          :positin => row[3] )

      if staff.save
        success += 1
      else
        failed_records << [row, staff]
        Rails.logger.info("#{row} ----> #{staff.errors.full_messages}")
      end
    end

    flash[:notice] = "共导入 #{success} 条，失败 #{failed_records.size} 条"
    redirect_to staffs_path(@staff)
  end
  # GET /staffs or /staffs.json
  def index
    @q = Staff.ransack(params[:q])
    @staffs = @q.result.page(params[:page]).per(1000)

    respond_to do |format|
      format.html
      format.csv {
        @staffs = @staffs.reorder("id ASC")
        csv_string = CSV.generate do |csv|
          csv << ["工号", "姓名", "部门", "职务"]
          @staffs.each do |staff|
            csv << [staff.number, staff.name, staff.department, staff.position ]
          end
        end
        send_data csv_string, :filename => "教职工信息-#{Time.now.to_s(:number)}.csv"
      }
    end
  end

  # GET /staffs/1 or /staffs/1.json
  def show
  end

  # 按工号搜索
  def search
    staff = Staff.find_by(number: params[:number])
    respond_to do |format|
        format.json { render json: staff }
    end
  end

  # GET /staffs/new
  def new
    @staff = Staff.new
  end

  # GET /staffs/1/edit
  def edit
  end

  # POST /staffs or /staffs.json
  def create
    @staff = Staff.new(staff_params)

    respond_to do |format|
      if @staff.save
        format.html { redirect_to @staff, notice: "添加成功。" }
        format.json { render :show, status: :created, location: @staff }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staffs/1 or /staffs/1.json
  def update
    respond_to do |format|
      if @staff.update(staff_params)
        format.html { redirect_to @staff, notice: "修改成功。" }
        format.json { render :show, status: :ok, location: @staff }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staffs/1 or /staffs/1.json
  def destroy
    @staff.destroy
    respond_to do |format|
      format.html { redirect_to staffs_url, alert: "删除成功。" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff
      @staff = Staff.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def staff_params
      params.require(:staff).permit(:number, :name, :department, :position)
    end
end
