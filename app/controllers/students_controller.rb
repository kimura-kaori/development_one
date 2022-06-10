class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :user_confirmation, only: %i[ show edit update destroy ]

  def index
    #ログインしているユーザーに紐づく生徒情報だけ表示.
    @students = Student.includes(:user).where(user_id: current_user.id)
  end

  def show
  end

  def new
    @student = Student.new
  end

  def edit
  end

  def create
    @student = current_user.students.build(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
      redirect_to students_url, notice: "Student was successfully destroyed."
  end

  def mypage
    @students = Student.includes(:user).where(user_id: current_user.id)
  end

  def report
    @student = Student.find(params[:student_id])
    ReportMailer.send_message_to_school(@student).deliver
  end

  private

    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:student_furigana, :student_name, :sex, :birthday, :telephone, :cellphone, :post_code, :address, :parents_furigana, :parents_name, :relationship)
    end

    def user_confirmation
      @student = Student.find(params[:id])
      @user = @student.user
      redirect_to root_path unless @user == current_user
    end
end
