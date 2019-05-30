import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  public readonly Pages: { [ pageName: string]: number } = {
    FORM:   0,
    RULES:  1,
    FAQ:    2,
  };

  public displayPage: number = this.Pages.FORM;

  public onClickFAQLink(): void {
    if (this.displayPage === this.Pages.FAQ) {
      this.displayPage = this.Pages.FORM;

      return;
    }

    this.displayPage = this.Pages.FAQ;
  }

  public onClickRulesLink(): void {
    if (this.displayPage === this.Pages.RULES) {
      this.displayPage = this.Pages.FORM;

      return;
    }

    this.displayPage = this.Pages.RULES;
  }

  public closePage(): void {
    this.displayPage = this.Pages.FORM;
  }
}
