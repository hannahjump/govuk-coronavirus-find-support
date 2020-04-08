RSpec.describe "self-employed" do
  describe "GET /self-employed" do
    let(:selected_option) { I18n.t("coronavirus_form.questions.self_employed.options").sample }

    context "without session data" do
      it "shows the form" do
        visit self_employed_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.questions.self_employed.title"))
        I18n.t("coronavirus_form.questions.self_employed.options").each do |option|
          expect(page.body).to have_content(option)
        end
      end
    end

    context "with session data" do
      before do
        page.set_rack_session(self_employed: selected_option)
      end

      it "shows the form with prefilled response" do
        visit self_employed_path

        expect(page.body).to have_content(I18n.t("coronavirus_form.questions.self_employed.title"))
        expect(page.find("input#option_#{selected_option.parameterize.underscore}")).to be_checked
      end
    end
  end

  describe "POST /self-employed" do
    let(:selected_option) { I18n.t("coronavirus_form.questions.self_employed.options").sample }

    it "updates the session store" do
      post self_employed_path, params: { self_employed: selected_option }

      expect(session[:self_employed]).to eq(selected_option)
    end

    xit "redirects to the next question" do
      post self_employed_path, params: { self_employed: selected_option }

      expect(response).to redirect_to(next_question_path)
    end

    xit "shows an error when no radio button selected" do
      post self_employed_path

      expect(response.body).to have_content(I18n.t("coronavirus_form.questions.self_employed.title"))
      expect(response.body).to have_content(I18n.t("coronavirus_form.questions.self_employed.custom_select_error"))
    end
  end
end
