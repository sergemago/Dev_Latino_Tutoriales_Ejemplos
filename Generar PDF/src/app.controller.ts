import { Controller, Get, Post, UseInterceptors, UploadedFiles, Body, Param, Res } from '@nestjs/common';
import { AnyFilesInterceptor } from '@nestjs/platform-express';
import { AppService } from './app.service';
import { diskStorage } from 'multer';
import path = require('path');
import { Observable, of } from 'rxjs';
import { join } from 'path';


@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get("pdf/download")
  async downloadPDF(@Res() res): Promise<void> {
    const buffer = await this.appService.generarPDF();

    res.set({
      'Content-Type': 'application/pdf',
      'Content-Disposition': 'attachment; filename=example.pdf',
      'Content-Length': buffer.length,
    })

    res.end(buffer);
  }


}
