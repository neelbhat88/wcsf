class Admin::StudentsController < ApplicationController
  def index
    @students = Student.all
  end

  def show
    @student = Student.find(params[:id])
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(params[:student])

    if @student.save
      redirect_to admin_students_path, notice: 'Student was successfully created.'
    else
      redirect_to  admin_students_path, alert: 'Sorry, something went wrong. Try again.'
    end
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])

    if @student.update_attributes(params[:student])
      redirect_to admin_students_path, notice: 'Student was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    redirect_to admin_students_url
  end
end
