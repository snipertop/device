class ComputersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_computer, only: %i[ show edit update destroy connect ]

  def import
    csv_string = params[:csv_file].read.force_encoding('utf-8')

    success = 0
    failed_records = []

    CSV.parse(csv_string) do |row|
      computer = Computer.new( code: row[0],brand: row[1],version: row[2],place: row[3],state: row[4], 
                               date: row[5],configure: row[6],remarks: row[7],staff_id: row[8])
      if computer.save
        success += 1
      else
        failed_records << [row, computer]
        Rails.logger.info("#{row} ----> #{computer.errors.full_messages}")
      end
    end

    flash[:notice] = "共导入 #{success} 条，失败 #{failed_records.size} 条"
    redirect_to computers_path(@computer)
  end

  # GET /computers or /computers.json
  def index
    @q = Computer.ransack(params[:q])
    @computers = @q.result.page(params[:page]).per(1000)

    respond_to do |format|
      format.html
      format.csv {
        @computers = @computers.reorder("id ASC")
        csv_string = CSV.generate do |csv|
          csv << ["编号", "品牌	", "版本", "位置", "状态", "日期", "配置", "备注", "工号"]
          @computers.each do |c|
            csv << [c.code, c.brand, c.version, c.place, c.state, c.date, c.configure, c.remarks, c.staff.number ]
          end
        end
        send_data csv_string, :filename => "设备信息-#{Time.now.to_s(:number)}.csv"
      }
    end
  end

  # GET /computers/1 or /computers/1.json
  def show
  end

  # GET /computers/new
  def new
    @computer = Computer.new
  end

  # 按工号搜索
  def modify
    computer = Computer.find(params[:id]).update(place: params[:place],state: params[:state],staff_id: params[:staff_id])
    respond_to do |format|
      if computer
        format.json { render json: computer }
      end
    end
  end

  # GET /computers/1/edit
  def edit
  end

  # POST /computers or /computers.json
  def create
    @computer = Computer.new(computer_params)

    respond_to do |format|
      if @computer.save
        format.html { redirect_to @computer, notice: "添加成功。" }
        format.json { render :show, status: :created, location: @computer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @computer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /computers/1 or /computers/1.json
  def update
    respond_to do |format|
      if @computer.update(computer_params)
        format.html { redirect_to @computer, notice: "修改成功。" }
        format.json { render :show, status: :ok, location: @computer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @computer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /computers/1 or /computers/1.json
  def destroy
    @computer.destroy
    respond_to do |format|
      format.html { redirect_to computers_url, alert: "删除成功。" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_computer
      @computer = Computer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def computer_params
      params.require(:computer).permit(:code, :brand, :version, :place, :state, :date, :configure, :remarks, :staff_id)
    end
end
