class ContactsController < ApplicationController

  def show
    @user = User.find(params[:user_id])
    @contact = Contact.find(params[:id])
    @comments = @contact.comments
    @comment = Comment.new
    redirect_to root_path unless @user == current_user || current_user.admin == true
  end

  def new
    @user = User.find(params[:user_id])
    @contact = Contact.new
  end

  def create
    @user = User.find(params[:user_id])
    @contact = @user.contacts.build(title: "下記へご入力ください。")

    respond_to do |format|
      if @contact.save
        format.html { redirect_to user_contact_path(@contact, @user), notice: "ご連絡を受け付けました。" }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end
end
