/* ========================================
 *
 * Copyright noritan.org, 2014
 * All Rights Reserved
 * UNPUBLISHED, LICENSED SOFTWARE.
 *
 * CONFIDENTIAL AND PROPRIETARY INFORMATION
 * WHICH IS THE PROPERTY OF NORITAN.ORG.
 *
 * ========================================
*/
#include <project.h>

// Software shift register
uint8       v[8] = {0};

// Show shift register contents and flags
void show(void) {
    uint8       i;
    
    LCD_Position(0, 0);
    for (i = 0; i < 8; i++) {
        LCD_PrintInt8(v[i]);
    }
    LCD_Position(1, 0);
    if (SR1_Read() & 1) {
        LCD_PrintString("FULL ");
    } else {
        LCD_PrintString("     ");
    }
    if (SR1_Read() & 2) {
        LCD_PrintString("EMPTY ");
    } else {
        LCD_PrintString("      ");
    }
}

int main(void) {
    uint8       x = 1;
    uint8       i;
    
    CR1_Write(0);
    
    LCD_Start();
    
    show();
    
    for(;;) {
        if (!SW2_Read()) {
            // PUSH button
            CY_SET_REG8(Fifo_dp_u0__F0_REG, x++);
            show();
            while (!SW2_Read()) {
                CyDelay(10);
            }
        }
        if (!SW3_Read()) {
            // PULL button
            for (i = 0; i < 7; i++) {
                v[i] = v[i+1];
            }
            v[7] = CY_GET_REG8(Fifo_dp_u0__F0_REG);
            show();
            while (!SW3_Read()) {
                CyDelay(10);
            }
        }
    }
}

/* [] END OF FILE */
