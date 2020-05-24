import {Component, OnChanges, Input, SimpleChange} from '@angular/core';

@Component({
    selector: 'password-strength-bar',
        styles: [`
    ul#strengthBar {
        display:inline;
        list-style:none;
        margin:0;
        margin-left:15px;
        padding:0;
        vertical-align:2px;
    }
    div#strength {
        text-align: left;
        color: #f69b22;
        padding-bottom: 10px;
    }
    .point:last {
        margin:0 !important;
    }
    .point {
        background:#DDD;
        border-radius:2px;
        display:inline-block;
        height:5px;
        margin-right:1px;
        width:20px;
    }`],
    template: `
    <div id="strength" #strength>
        <small>{{barLabel}}</small>
        <ul id="strengthBar">
            <li class="point" [style.background-color]="bar0"></li><li class="point" [style.background-color]="bar1"></li><li class="point" [style.background-color]="bar2"></li><li class="point" [style.background-color]="bar3"></li><li class="point" [style.background-color]="bar4"></li>
        </ul>
    </div>
`
})
export class PasswordStrengthBar implements OnChanges {
    @Input() passwordToCheck: string;
    @Input() barLabel: string;
    bar0: string;
    bar1: string;
    bar2: string;
    bar3: string;
    bar4: string;

    private colors = ['#F00', '#F90', '#FF0', '#9F0', '#0F0'];

    private static measureStrength(pass: string) {
        let score = 0;
        // award every unique letter until 5 repetitions
        let letters = {};
        for (let i = 0; i< pass.length; i++) {
        letters[pass[i]] = (letters[pass[i]] || 0) + 1;
        score += 5.0 / letters[pass[i]];
        }
        // bonus points for mixing it up
        let variations = {
        digits: /\d/.test(pass),
        lower: /[a-z]/.test(pass),
        upper: /[A-Z]/.test(pass),
        nonWords: /\W/.test(pass),
        };

        let variationCount = 0;
        for (let check in variations) {
        variationCount += (variations[check]) ? 1 : 0;
        }
        score += (variationCount - 1) * 10;
        return Math.trunc(score);
    }

  private getColor(score: number) {
    let idx = 0;
    if (score > 90) {
      idx = 4;
    } else if (score > 70) {
      idx = 3;
    } else if (score >= 40) {
      idx = 2;
    } else if (score >= 20) {
      idx = 1;
    }
    return {
      idx: idx + 1,
      col: this.colors[idx]
    };
  }

    ngOnChanges(changes: {[propName: string]: SimpleChange}): void {
        var password = changes['passwordToCheck'].currentValue;
        this.setBarColors(5, '#DDD');
        if (password) {
            let c = this.getColor(PasswordStrengthBar.measureStrength(password));
            this.setBarColors(c.idx, c.col);
        }
    }
    private setBarColors(count, col) {
        for (let _n = 0; _n < count; _n++) {
            this['bar' + _n] = col;
        }
    }
}
