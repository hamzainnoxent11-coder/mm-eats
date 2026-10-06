import { Injectable, UnauthorizedException } from '@nestjs/common';
import { randomBytes } from 'crypto';

interface OtpRecord {
  otp: string;
  expiresAt: number;
}

@Injectable()
export class AuthService {
  private otps = new Map<string, OtpRecord>();
  private tokens = new Map<string, string>();

  sendOtp(phone: string) {
    const otp = Math.floor(100000 + Math.random() * 900000).toString();

    this.otps.set(phone, {
      otp,
      expiresAt: Date.now() + 5 * 60 * 1000,
    });

    return {
      success: true,
      message: 'OTP generated successfully',
      phone,
      otp,
      expiresIn: 300,
    };
  }

  verifyOtp(phone: string, otp: string) {
    const record = this.otps.get(phone);

    if (!record || record.expiresAt < Date.now()) {
      throw new UnauthorizedException('OTP expired or not found');
    }

    if (record.otp !== otp) {
      throw new UnauthorizedException('Invalid OTP');
    }

    const token = randomBytes(32).toString('hex');

    this.tokens.set(token, phone);
    this.otps.delete(phone);

    return {
      success: true,
      message: 'Login successful',
      phone,
      token,
    };
  }
}
