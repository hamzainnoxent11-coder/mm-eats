import { Controller, Get } from '@nestjs/common';

@Controller('health')
export class HealthController {
  @Get()
  check() {
    return {
      status: 'ok',
      app: 'MM Eats',
      message: 'MM Eats backend is running',
    };
  }
}
