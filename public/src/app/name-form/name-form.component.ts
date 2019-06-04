import { Component, OnInit, ViewChild } from '@angular/core';
import { shuffle } from 'lodash';
import axios from 'axios';
import { ReCaptcha2Component } from 'ngx-captcha';
import { MatSnackBar } from '@angular/material';

const LOCALSTORAGE_GUESSOR_KEY = 'baby-name:guessor';

const defaultPlaceholders: ReadonlyArray<string> = Object.freeze([
  'Kalvin',
  'KiKi',
  'Kishawn',
  'Kiyaaani',
  'Krypto',
  'Karma',
  'Kai',
]);

@Component({
  selector: 'app-name-form',
  templateUrl: './name-form.component.html',
  styleUrls: ['./name-form.component.scss']
})
export class NameFormComponent implements OnInit {
  public readonly guessorRegex: RegExp = /[A-Z][A-Za-z']+ [A-Z][A-Za-z]+/;
  public readonly guessRegex: RegExp = /^K[A-Za-z]+$/;

  public showGuessorNameInput: boolean = true;

  public guessor: string;
  public recaptchaToken: string;
  public guesses: { name: string }[];

  public placeholders: string[];

  @ViewChild('recaptcha') public recaptcha: ReCaptcha2Component;

  constructor(private notifier: MatSnackBar) {}

  ngOnInit(): void {
    this.placeholders = shuffle(defaultPlaceholders);

    this.guessor = localStorage.getItem(LOCALSTORAGE_GUESSOR_KEY);
    if (this.guessor) {
      this.showGuessorNameInput = false;
    }

    this.guesses = [{
      name: '',
    }];

    this.recaptchaToken = '';
  }

  saveName(): void {
    if (!this.guessor || !this.guessorRegex.test(this.guessor)) {
      return;
    }

    localStorage.setItem(LOCALSTORAGE_GUESSOR_KEY, this.guessor);

    this.showGuessorNameInput = false;
  }

  addGuess(): void {
    this.guesses.push({
      name: '',
    });
  }

  removeGuess(index: number): void {
    this.guesses.splice(index, 1);

    if (!this.guesses.length) {
      this.addGuess();
    }
  }

  async submitGuesses(): Promise<void> {
    const isInvalid = this.guesses.some((guess: { name: string }): boolean => {
      return !this.guessRegex.test(guess.name);
    });

    if (isInvalid) {
      return;
    }

    this.guesses = this.guesses.filter((guess: { name: string }): boolean => {
      return guess.name && (guess.name.length > 1);
    });

    if (this.guesses.length === 0) {
      return this.addGuess();
    }

    if (!this.recaptchaToken) {
      return;
    }

    const guesses = this.guesses.map((guess) => {
      return guess.name;
    });

    try {
      await axios.post('/guesses', {
        recaptchaToken: this.recaptchaToken,
        guessor:        this.guessor,
        guesses,
      });

      this.ngOnInit();
      this.recaptcha.resetCaptcha();

      this.notifier.open('Guesses Submitted!', 'Ok', {
        duration: 4000,
      });
    } catch (err) {
      this.notifier.open(`Error submitting guesses: ${err.toString()}`, 'Ok', {
        duration: 4000,
      });
    }
  }
}
