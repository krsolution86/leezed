export class User {
    public id: number;
    public firstname: string;
    public remember:boolean;
    public lastname: string;
    public email: string;
    public Active: boolean = true;
    public password: string;//= "@welcome"
    public phone: string;
    public username: string;
    public zip: number;
    public disclaimerDate?: Date;
    public disclaimerVersion: Number;
    public disclaimerAccepted: boolean;
    public NotificationPreference: Number = 0;
    public oldpassword?: any = '';
    public newpassword?: any = '';
    public status: any;
    public createdAt: any;
    public updatedAt: any;
    public facebookID:any;
    public facebookToken:any;
    public facebookName: any;
    public emailVerificationToken: any;
    public emaiVerificationDate: any;
    public emailVerified: any;
    public passwordResetToken: any;

}